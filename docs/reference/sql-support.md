# SQL Support

This page documents ReadySet's SQL support. There are 3 main areas of support:

| Area | Details |
|------|-------------|
| [Table replication](#table-replication) | <p>ReadySet takes an initial snapshot of tables from the upstream MySQL or Postgres database and then uses the database's replication stream to keep the snapshot accurate as the tables change.</p><p>To successfully snapshot and replicate a table, ReadySet must support the data types of the columns, the character set in which the data is encoded, and changes to the table via writes and schema changes.</p> |
| [Query caching](#query-caching) | <p>Once ReadySet is replicating tables, ReadySet can cache the results of SQL queries run against those tables.</p><p>To successfully cache the results of a query, ReadySet must support the SQL features and syntax in the query.</p> |
| [SQL extensions](#sql-extensions) | ReadySet supports custom SQL commands for viewing queries that ReadySet has proxied to the upstream database, caching supported queries, viewing caches, and removing caches. |

!!! tip

    ReadySet is continually expanding SQL support. If you need an unsupported feature, let us know on the [Discord chat](https://discord.gg/readyset), or [open an issue](https://github.com/readysettech/readyset/issues/new/choose) in our GitHub repository.

## Table replication

### Data types

ReadySet can snapshot and replicate tables containing many [MySQL](https://dev.mysql.com/doc/refman/8.0/en/data-types.html) and [Postgres](https://www.postgresql.org/docs/current/datatype.html) data types.

<style>
  table thead tr th:first-child {
    width: 150px;
  }
</style>

=== "MySQL"

    **Numeric types**

    | Type | Supported | Notes |
    |------|------------|-------|
    | [`INT`<br>`INT UNSIGNED`<br>`TINYINT`<br>`TINYINT UNSIGNED`<br>`SMALLINT`<br>`SMALLINT UNSIGNED`<br>`MEDIUMINT`<br>`MEDIUMINT UNSIGNED`<br>`BIGINT`<br>`BIGINT UNSIGNED`<br>`SERIAL`](https://dev.mysql.com/doc/refman/8.0/en/integer-types.html) | :octicons-check-16: | ReadySet ignores the optional length field. |
    | [`DECIMAL`<br>`NUMERIC`](https://dev.mysql.com/doc/refman/8.0/en/fixed-point-types.html) | :octicons-check-16: | |
    | [`FLOAT`<br>`DOUBLE`<br>`REAL`](https://dev.mysql.com/doc/refman/8.0/en/floating-point-types.html) | :octicons-check-16: | |
    | [`BIT`](https://dev.mysql.com/doc/refman/8.0/en/bit-type.html) | :octicons-check-16: | ReadySet ignores the optional length field. |

    **Data and time types**

    | Type | Supported | Notes |
    |------|------------|-------|
    | [`DATE`<br>`DATETIME`<br>`TIMESTAMP`<br>`TIMESTAMPTZ`](https://dev.mysql.com/doc/refman/8.0/en/datetime.html) | :octicons-check-16: | ReadySet ignores the optional precision field. |
    | [`TIME`](https://dev.mysql.com/doc/refman/8.0/en/time.html) | :octicons-check-16: | |
    | [`YEAR`](https://dev.mysql.com/doc/refman/8.0/en/year.html) | :octicons-x-16:| |

    **String types**

    | Type | Supported | Notes |
    |------|------------|-------|
    | [`CHAR`<br>`VARCHAR`](https://dev.mysql.com/doc/refman/8.0/en/char.html) | :octicons-check-16: | ReadySet ignores the optional length field. |
    | [`BINARY`<br>`VARBINARY`](https://dev.mysql.com/doc/refman/8.0/en/binary-varbinary.html) | :octicons-check-16: | ReadySet ignores the optional length field. |
    | [`BLOB`<br>`TINYBLOG`<br>`MEDIUMBLOB`<br>`LONGBLOB`](https://dev.mysql.com/doc/refman/8.0/en/blob.html) | :octicons-check-16: | |
    | [`TEXT`<br>`TINYTEXT`<br>`MEDIUMTEXT`<br>`LONGTEXT`](https://dev.mysql.com/doc/refman/8.0/en/blob.html) | :octicons-check-16: | |
    | [`ENUM`](https://dev.mysql.com/doc/refman/8.0/en/enum.html) | :octicons-check-16: | |
    | [`SET`](https://dev.mysql.com/doc/refman/8.0/en/set.html) | :octicons-x-16: | |

    **JSON types**

    | Type | Supported | Notes |
    |------|------------|-------|
    | [`JSON`](https://dev.mysql.com/doc/refman/8.0/en/json.html) | :octicons-check-16: | ReadySet represents this type internally as a normalized string. This can cause different behavior than in MySQL with respect to expressions or sorting. |

    **Spatial types**

    | Type | Supported | Notes |
    |------|------------|-------|
    | [`GEOMETRY`<br>`POINT`<br>`LINESTRING`<br>`POLYGON`<br>`MULTIPOINT`<br>`MULTILINESTRING`<br>`MULTIPOLYGON`, `GEOMETRYCOLLECTION`](https://dev.mysql.com/doc/refman/8.0/en/spatial-type-overview.html) | :octicons-x-16: | |

=== "Postgres"

    **Numeric types**

    | Type | Supported | Notes |
    |------|-----------|-------|
    | [`INT`<br>`SMALLINT`<br>`BIGINT`](https://www.postgresql.org/docs/current/datatype-numeric.html#DATATYPE-INT) | :octicons-check-16: | ReadySet ignores the optional length field. |
    | [`DECIMAL`<br>`NUMERIC`](https://www.postgresql.org/docs/current/datatype-numeric.html#DATATYPE-NUMERIC-DECIMAL) | :octicons-check-16: | |
    | [`FLOAT`<br>`DOUBLE PRECISION`<br>`REAL`](https://dev.mysql.com/doc/refman/8.0/en/floating-point-types.html) | :octicons-check-16: | |
    | [`SERIAL`<br>`SMALLSERIAL`<br>`BIGSERIAL`](https://www.postgresql.org/docs/current/datatype-numeric.html#DATATYPE-SERIAL) | :octicons-check-16: | |

    **Monetary types**

    | Type | Supported | Notes |
    |------|-----------|-------|
    | [`MONEY`](https://www.postgresql.org/docs/current/datatype-money.html) | :octicons-x-16: |  |

    **Character types**

    | Type | Supported | Notes |
    |------|-----------|-------|
    | [`CHAR`<br>`VARCHAR`<br>`TEXT`](https://www.postgresql.org/docs/current/datatype-character.html) | :octicons-check-16: | ReadySet ignores the optional length field. |
    | [`CITEXT`](https://www.postgresql.org/docs/15/citext.html) | :octicons-check-16: | |

    **Binary types**

    | Type | Supported | Notes |
    |------|-----------|-------|
    | [`BYTEA`](https://www.postgresql.org/docs/current/datatype-binary.html) | :octicons-check-16: | |

    **Date and time types**

    | Type | Supported | Notes |
    |------|-----------|-------|
    | [`DATE`<br>`TIME`<br>`TIMETZ`<br>`TIMESTAMP`<br>`TIMESTAMPTZ`](https://www.postgresql.org/docs/current/datatype-datetime.html) | :octicons-check-16: | ReadySet ignores the optional precision field. |
    | [`INTERVAL`](https://www.postgresql.org/docs/current/datatype-datetime.html) | :octicons-x-16: | |

    **Boolean types**

    | Type | Supported | Notes |
    |------|-----------|-------|
    | [`BOOLEAN`](https://www.postgresql.org/docs/current/datatype-boolean.html) | :octicons-check-16: | |

    **Enumerated types**

    | Type | Supported | Notes |
    |------|-----------|-------|
    | [`ENUM`](https://www.postgresql.org/docs/current/datatype-enum.html) | :octicons-check-16: | |

    **Geometric types**

    | Type | Supported | Notes |
    |------|-----------|-------|
    | [`POINT`<br>`LINE`<br>`LSEG`<br>`BOX`<br>`PATH`<br>`POLYGON`<br>`CIRCLE`](https://www.postgresql.org/docs/current/datatype-geometric.html) | :octicons-x-16: | |

    **Network address types**

    | Type | Supported | Notes |
    |------|-----------|-------|
    | [`INET`](https://www.postgresql.org/docs/current/datatype-net-types.html#DATATYPE-INET) | :octicons-check-16: | ReadySet represents this type internally as normalized string. |
    | [`CIDR`](https://www.postgresql.org/docs/current/datatype-net-types.html#DATATYPE-CIDR) | :octicons-x-16: | |
    | [`MACADDR`](https://www.postgresql.org/docs/current/datatype-net-types.html#DATATYPE-MACADDR) | :octicons-check-16: | ReadySet represents this type internally as a normalized string. This can cause different behavior than in Postgres with respect to expressions or sorting.|
    | [`MACADDR8`](https://www.postgresql.org/docs/current/datatype-net-types.html#DATATYPE-MACADDR8) | :octicons-x-16: | |

    **Bit string types**

    | Type | Supported | Notes |
    |------|-----------|-------|
    | [`BIT`<br>`BIT VARYING`](https://www.postgresql.org/docs/current/datatype-bit.html) | :octicons-check-16: | ReadySet ignores the optional length field. |

    **Text search types**

    | Type | Supported | Notes |
    |------|-----------|-------|
    | [`tsvector`](https://www.postgresql.org/docs/current/datatype-textsearch.html#DATATYPE-TSVECTOR) | :octicons-x-16: | |
    | [`tsquery`](https://www.postgresql.org/docs/current/datatype-textsearch.html#DATATYPE-TSQUERY) | :octicons-x-16: | |

    **UUID types**

    | Type | Supported | Notes |
    |------|-----------|-------|
    | [`UUID`](https://www.postgresql.org/docs/current/datatype-uuid.html) | :octicons-check-16: | ReadySet represents this type internally as a normalized string. This can cause different behavior than in Postgres with respect to expressions or sorting. |

    **XML types**

    | Type | Supported | Notes |
    |------|-----------|-------|
    | [`XML`](https://www.postgresql.org/docs/current/datatype-xml.html) | :octicons-x-16: | |

    **JSON types**

    | Type | Supported | Notes |
    |------|------------|-------|
    | [`JSON`<br>`JSONB`](https://www.postgresql.org/docs/current/datatype-json.html) | :octicons-check-16: | ReadySet represents this type internally as a normalized string. This can cause different behavior than in Postgres with respect to expressions or sorting. |

    **Array types**

    | Type | Supported | Notes |
    |------|------------|-------|
    | [`ARRAY`](https://www.postgresql.org/docs/current/arrays.html) | :octicons-check-16:| |

    **Composite data types**

    | Type | Supported | Notes |
    |------|------------|-------|
    | [`CREATE TYPE <name> AS`](https://www.postgresql.org/docs/current/rowtypes.html) | :octicons-x-16:| |

    **Range types**

    | Type | Supported | Notes |
    |------|------------|-------|
    | [`INT4RANGE`<br>`INT8RANGE`<br>`NUMRANGE`<br>`TSRANGE`<br>`TSTZRANGE`<br>`DATERANGE`](https://www.postgresql.org/docs/current/rangetypes.html) | :octicons-x-16: | |

    **Domain types**

    | Type | Supported | Notes |
    |------|------------|-------|
    | [`CREATE TABLE <table> (col <domain>)`](https://www.postgresql.org/docs/current/domains.html) | :octicons-x-16: | |

    **Object identifier types**

    | Type | Supported | Notes |
    |------|------------|-------|
    | [`OID`<br>`REGCLASS`<br>`REGCOLLATION`<br>`REGCONFIG`<br>`REGDICTIONARY`<br>`REGNAMESPACE`<br>`REGOPER`<br>`REGOPERATOR`<br>`REGPROC`<br>`REGPROCEDURE`<br>`REGROLE`<br>`REGTYPE`](https://www.postgresql.org/docs/current/datatype-oid.html) | :octicons-x-16: | |


### Character sets

ReadySet supports the UTF-8 character set for strings and compares strings case-sensitively and sorts strings lexicographically. ReadySet does not support other character sets, alternative collations, or comparison methods for strings. However, you can use the `CITEXT` data type in Postgres to emulate a case-insensitive collation, and you can use the `BYTEA` data type in Postgres and the `BINARY` data type in MySQL to store arbitrary binary data.

### Writes

All `INSERT`, `UPDATE`, and `DELETE` statements sent to ReadySet are proxied to the upstream database. ReadySet receives new/changed data via the database's replication stream and updates its snapshot and cache automatically.  

### Schema changes

When ReadySet receives the following schema change commands via the replication stream, ReadySet updates its snapshot of the affected tables and removes the caches of related queries.

!!! tip

     After running any of the following schema change commands, be sure to [re-cache related queries](../guides/cache-queries.md).

=== "MySQL"

    | Statement | Command | Notes |
    |-----------|--------|-------|
    | `ALTER TABLE` | `ADD COLUMN` | |
    | `ALTER TABLE` | `ADD KEY` | |
    | `ALTER TABLE` | `DROP COLUMN` | |
    | `ALTER TABLE` | `ALTER COLUMN` | ReadySet supports only `SET DEFAULT [literal]` and `DROP DEFAULT`. |
    | `ALTER TABLE` | `CHANGE COLUMN` | |
    | `ALTER TABLE` | `MODIFY COLUMN` | ReadySet does not support `FIRST` or `AFTER`. |

=== "Postgres"

    | Statement | Command | Notes |
    |-----------|--------|-------|
    | `ALTER TABLE` | `ADD COLUMN` | |
    | `ALTER TABLE` | `ADD KEY` | |
    | `ALTER TABLE` | `DROP COLUMN` | |
    | `ALTER TABLE` | `ALTER COLUMN` | ReadySet supports only `SET DEFAULT [literal]` and `DROP DEFAULT`. |
    | `ALTER TABLE` | `CHANGE COLUMN` | |
    | `ALTER TABLE` | `MODIFY COLUMN` | ReadySet does not support `FIRST` or `AFTER`. |
    | `ALTER TYPE` | `ADD VALUE` | ReadySet removes the caches of queries referencing the type but does not update the snapshot of tables including the type. |
    | `ALTER TYPE` | `RENAME TO` | ReadySet removes the caches of queries referencing the type but does not update the snapshot of tables including the type. |
    | `ALTER TYPE` | `RENAME VALUE` | ReadySet removes the caches of queries referencing the type but does not update the snapshot of tables including the type. |
    | `ALTER TYPE` | `SET SCHEMA` | ReadySet removes the caches of queries referencing the type but does not update the snapshot of tables including the type. |

### Namespaces

ReadySet supports [Postgres schemas](https://www.postgresql.org/docs/current/ddl-schemas.html) (namespaces for tables).

## Query caching

!!! tip

    You can use the [ReadySet dashboard](dashboard.md) to check if queries are supported by ReadySet. ReadySet always proxies unsupported queries to the upstream database.

### Clauses

ReadySet supports the following clauses in SQL `SELECT` queries:

- `SELECT` with a list of select expressions, all of which must be supported expressions (see “[Expressions](#expressions)”)
    - ReadySet does not support scalar subqueries in the `SELECT` clause.
- `DISTINCT`, modifying the select clause
- `FROM`, with a list of tables (which may be implicitly joined)
- `JOIN` (see ["Joins"](#joins))
- `WHERE`
- `GROUP BY`, with a list of column or numeric field references
    - ReadySet does not support [expression](#expressions) in the `GROUP BY` clause.
    <!-- Test this. -->
- `HAVING`
    - ReadySet does not support [parameters](#parameters) in the `HAVING` clause.
- `ORDER BY`, with a list of [expressions](#expressions) and an optional `ASC` or `DESC` specifier
- `LIMIT`
- `OFFSET`
- `WITH` (common table expressions)
    - ReadySet does not support recursive common table expressions (`WITH RECURSIVE`).

There are specific top-level clauses and other query conditions that ReadySet does not yet support, including:

- `UNION`, `INTERSECT`, or `EXCEPT` as operators to combine multiple `SELECT` statements
- `WINDOW`
- `ORDER BY` with `NULLS FIRST` or `NULLS LAST`

### Joins

ReadySet supports the following `JOIN` types:

- `[INNER] JOIN`: Only the rows from the left and right side that match the condition are returned.
- `LEFT [OUTER] JOIN`: For every left row where there is no match on the right, `NULL` values are returned for the columns on the right.

Note that the right side of a `JOIN` can be a subquery but must not be correlated.

The primary limitation is on the **condition** of a `JOIN`. If using the `ON` clause with a join condition expression, the condition must be either a single equality comparison between a column on a table appearing outside the join and the join table (or subquery), or multiple such expressions combined using `AND`. For example, the following queries are supported:

``` sql
SELECT * FROM t1
  JOIN t2 ON t1.id = t2.t1_id;
```
``` sql
SELECT * FROM t1
  JOIN t2 ON t1.x = t2.x AND t1.y = t2.y;
```
``` sql
SELECT * FROM t1
  JOIN t2 ON t1.x = t2.x
  JOIN t3 ON t1.y = t3.y;
```

But the following queries are not supported:

``` sql
-- This query doesn't compare a column in one table to a column in another table
SELECT * FROM t1
  JOIN t2 ON t1.x = t1.y;
```
```  sql  
-- This query doesn't compare using equality
SELECT * FROM t1
  JOIN t2 ON t1.x > t2.x;
```
``` sql
-- This query doesn't combine its equality join keys with AND
SELECT * FROM t1
  JOIN t2 ON t1.x = t2.x OR t1.y = t2.y;
```

In addition, multiple tables specified in the `FROM` clause can be **implicitly** joined, but only if there is a condition in the `WHERE` clause that follows the above requirements when expressed in conjunctive normal form. For example, the following query is supported:

``` sql
SELECT * FROM t1, t2 WHERE t1.x = t2.x
```

But the following query is not:

``` sql
SELECT * FROM t1, t2 WHERE t1.x = t1.y;
```

### Expressions

ReadySet supports the following components of the SQL expression language:

- Literal values
    - String literals, quoted according to the SQL dialect being used (single quotes for PostgreSQL, double or single quotes for MySQL)
        - ReadySet does not support string literals with charset or collation specifications
    - Integer literals
    - Float literals
        - ReadySet does not support float literals using scientific (exponential) notation
    - `NULL` literal
    - Boolean literals `TRUE` and `FALSE`
    - Array literals
- Operators <!-- http://docs/rustdoc/dataflow_expression/enum.BinaryOperator.html -->
    - `AND`
    - `OR`
    - `LIKE`
    - `NOT LIKE`
    - `ILIKE`
    - `NOT ILIKE`
    - `=`
    - `!=` or `<>`
    - `>`
    - `>=`
    - `<`
    - `<=`
    - `IS NULL`
    - `IS NOT NULL`
    - `+`
    - `-`
    - `*`
    - `/`
    - Unary `-`
    - Unary `NOT`
    - `BETWEEN`
    - `EXISTS`
    - `?`
    - `?|`
    - `?&`
- `IN` and `NOT IN` with a list of expressions
    - see "Limitations of `IN`" under [“Parameters”](#parameters)
- `CAST`
- `CASE`
    - `Case` may only have one `THEN` branch and an optional `ELSE` branch
- Built-in functions <!-- http://docs/rustdoc/dataflow_expression/enum.BuiltinFunction.html -->
    - `CONVERT_TZ()`
    - `DAYOFWEEK()`
    - `IFNULL()`
    - `MONTH()`
    - `TIMEDIFF()`
    - `ADDTIME()`
    - `ROUND()`
    - `JSON_TYPEOF()`
    - `JSONB_TYPEOF()`
    - `COALESCE()`
    - `SUBSTR()` and `SUBSTRING()`
    - `SPLIT_PART()`
    - `GREATEST()`
    - `LEAST()`
- Aggregate functions (see [Aggregations](#aggregations))  

ReadySet does not support the following components of the SQL expression language (this is not an exhaustive list):

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

### Aggregations

ReadySet supports the following aggregate functions:
<!-- http://docs/rustdoc/nom_sql/expression/enum.FunctionExpr.html -->
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

``` sql
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
```

While in ReadySet:

``` sql
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
```

### Parameters

ReadySet uses the **parameters** in a prepared statement, specified either positionally (using `?`) or numbered (using `$1`, `$2`, etc.), as the **key** that enables storing only certain result sets for each query. ReadySet will automatically turn literal values in certain positions in queries into parameters, but only supports certain positions for **user-specified parameters** in queries:

- Parameters can only appear in the `WHERE` clause of the outermost `SELECT` statement in a query (e.g., not in any subqueries).
    - Parameters are only supported in the `WHERE` clause of a query if, when expressed in conjunctive normal form, all conjunctive subexpressions of the expression in the `WHERE` clause either contain no parameters, or can be expressed as a single equality comparison between a column and a parameter, **or** are an `IN` expression where the right-hand side consists of a list of **only** parameters (ReadySet does not support mixing parameters and other types of expressions on the right-hand side of an `IN` expression).
    - ReadySet contains experimental support for conditions that consist of an **inequality** comparison between a parameter and a column (`>`, `>=`, `<` and `<=`)
- Parameters can also appear as the value of the `LIMIT` or `OFFSET` clause of a query.

!!! note "Limitations of `IN`"

    When the `IN` clause is used with parameters, queries may not contain the `AVG` or `GROUP_CONCAT` aggregate functions. However, this limitations does not apply when the right-hand side of the `IN` clause does not contain any query parameters.

## SQL extensions

ReadySet supports the following custom SQL commands for viewing queries that ReadySet has proxied to the upstream database, caching supported queries, viewing cached queries, and dropping caches:

- `SHOW PROXIED QUERIES`
- `CREATE CACHE`
- `SHOW CACHES`
- `DROP CACHE`

For more details about these commands, see [Cache Queries](../guides/cache-queries.md).
