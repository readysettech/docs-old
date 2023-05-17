---
hide:
  - navigation
  - toc
---

# ReadySet Docs

ReadySet is a lightweight SQL caching engine that sits between your application and database and turns even the most complex SQL reads into lightning-fast lookups. Unlike other caching solutions, ReadySet keeps the cache up-to-date automatically and requires no changes to your application code.

<style>
* {
  box-sizing: border-box;
}

/* Create three equal columns that floats next to each other */
.column {
  float: left;
  width: 33.33%;
  padding: 10px;
  /* height: 300px; Should be removed. Only for demonstration */
}

/* Clear floats after the columns */
.row:after {
  content: "";
  display: table;
  clear: both;
}

/* Responsive layout - makes the three columns stack on top of each other instead of next to each other */
@media screen and (max-width: 600px) {
  .column {
    width: 100%;
  }
}
</style>

<div class="row">
  <div class="column">
    <a href="guides/intro/intro/"><h4>About ReadySet</h4></a>
    <p>Learn how ReadySet works and when it's a good fit for an application</p>
  </div>
  <div class="column">
    <a href="guides/intro/quickstart/"><h4>Quickstart</h4></a>
    <p>Get started with a local deployment of Postgres and ReadySet</p>
  </div>
  <div class="column">
    <a href="guides/intro/playground/"><h4>Playground</h4></a>
    <p>Interact with ReadySet directly in your browser</p>
  </div>
</div>
<div class="row">
  <div class="column">
    <a href="guides/deploy/deploy-readyset-cloud/"><h4>Run with ReadySet Cloud</h4></a>
    <p>Get early access to a fully-managed deployment of ReadySet</p>
  </div>
  <div class="column">
    <a href="guides/deploy/deploy-readyset-binary/"><h4>Run with Binary</h4></a>
    <p>Deploy ReadySet yourself with the ReadySet binary</p>
  </div>
  <div class="column">
    <a href="guides/deploy/deploy-readyset-kubernetes/"><h4>Run with Kubernetes</h4></a>
    <p>Deploy ReadySet yourself with the ReadySet Helm chart</p>
  </div>
</div>
<div class="row">
  <div class="column">
    <a href="guides/connect/existing-app/"><h4>Connect an App</h4></a>
    <p>Connect your application by swapping out your database connection string</p>
  </div>
  <div class="column">
    <a href="guides/cache/cache-queries/"><h4>Cache Queries</h4></a>
    <p>Identify supported queries and cache their results in-memory</p>
  </div>
  <div class="column">
    <a href="reference/sql-support/"><h4>SQL Support</h4></a>
    <p>Find out which parts of the SQL language are supported by ReadySet</p>
  </div>
</div>
