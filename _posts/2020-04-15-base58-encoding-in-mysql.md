---
title: "Base-58 Encoding really big numbers in MySQL (5.6>)(128 bit)"
layout: post
tags: dev mysql
---

Encoding in base-58 numbers in MySQL is fairly straight forward until you start to overflowing integer types.  If you search for base-58 encoding in MySQL there is not a lot of info.  Micah Walter has a clean [function called base58_encode](https://gist.github.com/micahwalter/d6c8f8bc677978cf01a5) that works well until you toss in anything larger than a BIGINT.  It overflows:

<img class="screenshot" src="https://s3-us-west-2.amazonaws.com/chrisschuld.com/images/base58_encode.png"/>

If you are using base-58 encoding to create unique identifiers you run into problems sending in really large hash values.  A UUID a perfect example at 128bits of data.  A UUID's 128bits overflows the BIGINT quickly and you quickly end up with the infamous -1: 18446744073709551615.

<img class="screenshot" src="https://s3-us-west-2.amazonaws.com/chrisschuld.com/images/overflow_mysql_base58.png"/>

In MySQL you can use Decimal types to work around this and can create an encoder that will encode really large numbers.  Decimal in MySQL is not stored with an FPU but is stored as characters.  However, can you can still do `MOD()` and mathematics on it which is all we need for encoding.

Here is how I encode really big numbers using DECIMAL instead of **BIGINT** to provide a wider result.  This solutions uses a MySQL function and is using the Bitcoin alphabet:

```sql
-- Change delimiter so that the function body doesn't end the function declaration
DELIMITER //
CREATE FUNCTION base58_encode(input VARCHAR(64))
  RETURNS CHAR(22) DETERMINISTIC
BEGIN
  DECLARE alphabet char(58);
  DECLARE b DECIMAL(64) DEFAULT 0;
  DECLARE i INT DEFAULT 0;
  DECLARE u58 CHAR(22) DEFAULT "";

  SET alphabet = '123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz';
  SET b = convert(hex(input),DECIMAL(64,0));

  WHILE b > 0 DO
    SET i = MOD(b,58);
    SET u58 = CONCAT(SUBSTRING(alphabet FROM i FOR 1), u58);
    SET b = b / 58;
  END WHILE;

  SET u58 = CONCAT(SUBSTRING(alphabet FROM i FOR 1), u58);

  RETURN (u58);

END
//

-- Switch back the delimiter
DELIMITER ;
```

I typically build solutions with [public facing identifiers that are built from UUIDs](/2020/04/an-application-building-block-unique-ids-for-things/).  For this I use [ssvac's solution for v4 UUIDs](https://stackoverflow.com/questions/32965743/how-to-generate-a-uuidv4-in-mysql) and I combine it into a single function called **uuid_base58** - this way I can create IDs automatically at the dB level.

```sql
-- Change delimiter so that the function body doesn't end the function declaration
DELIMITER //

CREATE FUNCTION uuid_v4_no_dash()
    RETURNS CHAR(36)
BEGIN
    -- Generate 8 2-byte strings that we will combine into a UUIDv4
    SET @h1 = LPAD(HEX(FLOOR(RAND() * 0xffff)), 4, '0');
    SET @h2 = LPAD(HEX(FLOOR(RAND() * 0xffff)), 4, '0');
    SET @h3 = LPAD(HEX(FLOOR(RAND() * 0xffff)), 4, '0');
    SET @h6 = LPAD(HEX(FLOOR(RAND() * 0xffff)), 4, '0');
    SET @h7 = LPAD(HEX(FLOOR(RAND() * 0xffff)), 4, '0');
    SET @h8 = LPAD(HEX(FLOOR(RAND() * 0xffff)), 4, '0');

    -- 4th section will start with a 4 indicating the version
    SET @h4 = CONCAT('4', LPAD(HEX(FLOOR(RAND() * 0x0fff)), 3, '0'));

    -- 5th section first half-byte can only be 8, 9 A or B
    SET @h5 = CONCAT(HEX(FLOOR(RAND() * 4 + 8)),
                LPAD(HEX(FLOOR(RAND() * 0x0fff)), 3, '0'));

    -- Build the complete UUID
    RETURN LOWER(CONCAT(
        @h1, @h2, @h3, @h4, @h5, @h6, @h7, @h8
    ));
END
//
-- Switch back the delimiter
DELIMITER ;

-- Change delimiter so that the function body doesn't end the function declaration
DELIMITER //
CREATE FUNCTION uuid_base58()
  RETURNS CHAR(22) DETERMINISTIC
BEGIN
  DECLARE alphabet char(58);
  DECLARE b DECIMAL(64) DEFAULT 0;
  DECLARE i INT DEFAULT 0;
  DECLARE u58 CHAR(22) DEFAULT "";

  SET alphabet = '123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz';
  SET b = convert(hex(uuid_v4_no_dash()),DECIMAL(64,0));

  WHILE b > 0 DO
    SET i = MOD(b,58);
    SET u58 = CONCAT(SUBSTRING(alphabet FROM i FOR 1), u58);
    SET b = b / 58;
  END WHILE;

  RETURN (u58);

END
//

-- Switch back the delimiter
DELIMITER ;
```

This allows me to easily create UUIDs at the dB level:

<img class="screenshot" src="https://s3-us-west-2.amazonaws.com/chrisschuld.com/images/select_uuid_base58.png"/>
