# Query Support

The intricacies of whether particular queries are supported by ReadySet depend on multiple variables.

**Importantly, you do not have to do work to figure out if your particular queries are supported by ReadySet.**

The easiest way to determine which queries are supported is to refer to the [ReadySet dashboard](/using/dashboard), which will display information about whether individual queries are supported by ReadySet for you.

## Query Structure

ReadySet supports the following clauses in SQL SELECT queries:
- `SELECT` with a list of select expressions, all of which must be supported expressions (see “[Expressions](#expressions)”)
    - ReadySet does not support scalar subqueries in the `SELECT` clause
- `DISTINCT`, modifying the select clause
- `FROM`, with a list of tables (which may be implicitly joined), and (uncorrelated) subqueries
- `JOIN` (see ["Joins"](#joins))
- `WHERE`
    - The `WHERE` clause must have a single condition [expression](#expressions)
- `GROUP BY`, with a list of **column references**
    - ReadySet does not support expressions or field positions in the `GROUP BY` clause
- `ORDER BY`, with a list of [expression](#expressions) and an optional ASC or DESC specifier
- `LIMIT`
- `OFFSET`

There are specific top-level clauses and other query conditions that ReadySet does not yet support.

Notably, ReadySet does not support any of the following (this is not an exhaustive list):
- `HAVING`
- `UNION`, `INTERSECT`, or `EXCEPT` as operators to combine multiple `SELECT` statements
- `WINDOW`
- `ORDER BY` with `NULLS FIRST` or `NULLS LAST`

Support for additional operators is always expanding! Reach out to us in [Slack](https://join.slack.com/t/readysetcommunity/shared_invite/zt-1c7bxdxo7-Y6KuoLfc1YWagLk3xHSrsw) if you need an unsupported feature and we'll look into it.

## Joins
ReadySet supports a limited form of the SQL `JOIN` clause:
- only `LEFT` and `INNER` joins are supported
- the right-hand side of a join may be a subquery, but may not be correlated

The primary limitation is on the **condition** of a JOIN. If using the `ON` clause with a join condition expression, the condition may only be either a single equality comparison between a column on a table appearing outside the join and the join table (or subquery), or multiple such expressions combined using AND. For example, the following queries are supported:

~~~~sql
select * from t1
join t2 on t1.id = t2.t1_id
select * from t1
join t2 on t1.x = t2.x AND t1.y = t2.y
select * from t1
join t2 on t1.x = t2.x
join t3 on t1.y = t3.y
~~~~

But the following queries are not supported:

~~~~sql
-- This query doesn't compare a column in one table to a column in another table
select * from t1 join t2 on t1.x = t1.y
-- This query doesn't compare using equality
select * from t1 join t2 on t1.x > t2.x
-- This query doesn't combine its equality join keys with AND
select * from t1 join t2 on t1.x = t2.x OR t1.y = t2.y
~~~~

In addition, multiple tables specified in the FROM clause can be **implicitly** joined, but only if there is a condition in the WHERE clause that follows the above requirements when expressed in conjunctive normal form. For example, the following query is supported:

~~~~sql
select * from t1, t2 where t1.x = t2.x
~~~~

but the following query is not:

~~~~sql
select * from t1, t2 where t1.x = t1.y
~~~~

## Expressions

### Supported
ReadySet supports the following components of the SQL expression language:
- Literal values
    - String literals, quoted according to the SQL dialect being used (single quotes for postgresql, double or single quotes for mysql)
        - ReadySet does not support string literals with charset or collation specifications
    - Integer literals
    - Float literals
        - ReadySet does not support float literals using scientific (exponential) notation
    - the `NULL` literal
    - the `CURRENT_TIMESTAMP`, `CURRENT_DATE`, and `CURRENT_TIME` literals
    - boolean literals `TRUE` and `FALSE`
- Operators
    - `AND`
    - `OR`
    - `LIKE`, `NOT LIKE`
    - `ILIKE`, `NOT ILIKE`
    - `=`
    - `!=`, `<>`
    - `>`, `>=`, `<`, `<=`
    - `IS NULL`, `IS NOT NULL`
    - `+`, `-`, `*`, `/`
    - Unary `-`
    - Unary `NOT`
    - `BETWEEN`
- `IN` and `NOT IN` with a list of expressions
    - see "Limitations of `IN`" under [“Parameters”](#parameters)
- `CAST`
- `CASE`
    - `Case` may only have one `THEN` branch and an optional `ELSE` branch
- Functions
    - `convert_tz`
    - `dayofweek`
    - `ifnull`
    - `month`
    - `timediff`
    - `addtime`
    - `round`

### Unsupported

ReadySet does not support any of the following components of the SQL expression language (this is not an exhaustive list):
- Literals
    - `DATE` and `TIME` specifications for literals
    - Hexadecimal literals
- Bit-Value literals
- User-defined variables
- Operators: `|`, `&`, `<<`, `>>`, `DIV`, `MOD`, `%`, `^`, `<=>`, `SOUNDS LIKE`
- `COLLATE` specifiers
- Unary `+`, `~`, `!`
- `ROW` expressions
- Tuple expressions
- `LIKE` with an `ESCAPE` specifier
- `INTERVAL`
- `IN` or `NOT IN` with a subquery
- `ANY` or `SOME` subquery expressions
- `EXISTS` with a subquery

## Aggregations

ReadySet supports the following aggregate functions:
- `AVG(expr)`
- `AVG(DISTINCT expr)`
- `COUNT(expr)`
- `COUNT(DISTINCT expr)`
- `COUNT(*)`
- `SUM(expr)`
- `SUM(DISTINCT expr)`
- `MAX(expr)`
- `MIN(expr)`
- `GROUP_CONCAT(expr SEPARATOR str_val)`
    - ReadySet does not support the `ORDER BY` clause in the `GROUP_CONCAT` aggregate function, and requires the specification of a SEPARATOR (unlike MySQL, where the SEPARATOR is optional)

Similar to many SQL databases, ReadySet requires all columns in the `SELECT` clause or `ORDER BY` list that aren't in an aggregate function to be explicitly listed in the `GROUP BY` clause. This corresponds to the MySQL `ONLY_FULL_GROUP_BY` SQL mode.

If one or more aggregate functions appear in the column list of a subquery which returns no results, ReadySet will consider that subquery to **also** emit no results. This differs slightly from the handling of aggregates over empty result sets in MySQL. For example, in MySQL:

~~~~bash
MySQL [test]> select count(*) from empty_table;
+----------+
| count(*) |
+----------+
|        0 |
+----------+
1 row in set

MySQL [test]> select count(*) from (select count(*) from empty_table) as subquery;
+----------+
| count(*) |
+----------+
|        1 |
+----------+
1 row in set
~~~~

While in ReadySet:

~~~~bash
MySQL [test]> select count(*) from empty_table;
+----------+
| count(*) |
+----------+
|        0 |
+----------+
1 row in set

MySQL [test]> select count(*) from (select count(*) from empty_table) as subquery;
+----------+
| count(*) |
+----------+
|        0 |
+----------+
1 row in set
~~~~

## Parameters

ReadySet uses the **parameters** in a prepared statement, specified either positionally (using `?`) or numbered (using `$1`, `$2`, etc.), as the **key** that enables storing only certain result sets for each query. ReadySet will automatically turn literal values in certain positions in queries into parameters, but only supports certain positions for **user-specified parameters** in queries:
- Parameters can only appear in the `WHERE` clause of the outermost `SELECT` statement in a query (e.g., not in any subqueries).
    - Parameters are only supported in the `WHERE` clause of a query if, when expressed in conjunctive normal form, all conjunctive subexpressions of the expression in the `WHERE` clause either contain no parameters, or can be expressed as a single equality comparison between a column and a parameter, **or** are an `IN` expression where the right-hand side consists of a list of **only** parameters (ReadySet does not support mixing parameters and other types of expressions on the right-hand side of an `IN` expression).
    - ReadySet contains experimental support for conditions that consist of an **inequality** comparison between a parameter and a column (`>`, `>=`, `<` and `<=`)
- Parameters can also appear as the value of the `LIMIT` or `OFFSET` clause of a query.

### Limitations of `IN`

When the IN clause is used with parameters, queries may not contain the following elements:
- Some aggregate functions (`AVG`, or `GROUP_CONCAT`)

These limitations do not apply when the right-hand side of the `IN` clause does not contain any query parameters.

## Schema

### Types

ReadySet supports the following data types:
- `BOOL`
- `CHAR`
    - ReadySet will parse, but ignores, the optional length field
- `VARCHAR`
    - ReadySet will parse, but ignores, the optional length field
- `INT`
    - ReadySet will parse, but ignores, the optional padding field
- `INT UNSIGNED`
    - ReadySet will parse, but ignores, the optional padding field
- `BIGINT`
    - ReadySet will parse, but ignores, the optional padding field
- `BIGINT UNSIGNED`
    - ReadySet will parse, but ignores, the optional padding field
- `SMALLINT`
    - ReadySet will parse, but ignores, the optional padding field
- `SMALLINT UNSIGNED`
    - ReadySet will parse, but ignores, the optional padding field
- `BLOB`
- `LONGBLOG`
- `MEDIUMBLOB`
- `TINYBLOB`
- `DOUBLE`
- `FLOAT`
- `REAL`
- `NUMERIC`
- `TINYTEXT`
- `MEDIUMTEXT`
- `LONGTEXT`
- `TEXT`
- `DATE`
- `DATETIME`
    - ReadySet will parse, but ignores the optional precision field
- `TIME`
- `TIMESTAMP` / `TIMESTAMP WITHOUT TIME ZONE`
    - ReadySet will parse, but ignores the optional precision field
- `TIMESTAMPTZ` / `TIMESTAMP WITH TIME ZONE`
    - ReadySet will parse, but ignores the optional precision field
- `BINARY`
    - ReadySet will parse, but ignores the optional length field
- `VARBINARY`
    - ReadySet will parse, but ignores the optional length field
- `DECIMAL`
- `BYTEARRAY`
- `BIT`
    - ReadySet will parse, but ignores the optional length field
- `VARBIT`
    - ReadySet will parse, but ignores the optional length field
- `SERIAL`
- `BIGSERIAL`

ReadySet additionally has limited support for the following data types:
- `JSON`
- `JSONB`
- `UUID`
- `MACADDR`
- `INET`

All of the above data types will be snapshotted and replicated by ReadySet, but represented internally as normalized text strings, which may cause them to behave differently with respect to expressions or sorting than in MySQL or Postgres.

### Character sets
ReadySet stores all strings internally as UTF-8. ReadySet does not support any other character encoding for strings (though you can use the `BYTEA` SQL type to store arbitrary binary data), nor does it support any alternative collations or comparison methods (for example, strings in ReadySet are always compared case-sensitively, and always sorted character-wise lexicographically).

### Miscellaneous schema support
ReadySet does not support [schemas](https://www.postgresql.org/docs/current/ddl-schemas.html) (namespaces for tables).
