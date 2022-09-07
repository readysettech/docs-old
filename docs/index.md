# ReadySet

ReadySet is a MySQL and Postgres wire-compatible SQL caching engine that helps you to cache a subset of the traffic being sent to
your database without changing your app code or worrying about keeping cached state up to date.

Under the hood, ReadySet precomputes the results of prepared statements (i.e., parameterized SQL queries) and incrementally updates
these results over time as the underlying data in your database changes. You can read more about how ReadySet works in the
[Concepts](/concepts/overview) section.

![Architecture](/readyset_arch.png)
