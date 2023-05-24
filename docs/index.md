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
  width: 100%;
  padding: 10px 20px;
  border: 1px solid var(--gray7);
  border-radius: 6px;
}

.column:hover {
  border: 1px solid var(--gray8);
  transition: all 150ms ease-out; 
}

/* Clear floats after the columns */
.row {
  display: flex;
  width: 100%;
  gap: 32.5px;
}

/* Clear floats after the columns */
.row:after {
  content: "";
  display: table;
  clear: both;
}

.headerlink {
  display: none !important;
}

.md-content__button {
  display: none !important;
}

</style>

## Try ReadySet

<div class="row">
  <a class="column" href="guides/intro/quickstart/">
    <h4>Quickstart</h4>
    <p>Get started with a local deployment of Postgres and ReadySet</p> 
  </a>
  <a class="column" href="guides/intro/playground/">
    <h4>Playground</h4>
    <p>Interact with ReadySet directly in your browser</p>
  </a>
</div>

## Deploy ReadySet

<div class="row">
  <a class=column href="guides/deploy/deploy-readyset-binary/">
    <h4>Run with Binary</h4>
    <p>Deploy to Linux with the ReadySet binary</p>
  </a>
  <a class="column" href="guides/deploy/deploy-readyset-kubernetes/">
    <h4>Run with Kubernetes</h4>
    <p>Deploy to Kubernetes with the ReadySet Helm chart</p>
  </a>
</div>

## Next steps

<div class="row"> 
  <a href="guides/connect/existing-app/" class="column">
    <h4>Connect an App</h4>
    <p>Connect your application to ReadySet</p>
  </a>
  <a href="guides/cache/cache-queries/" class="column">
    <h4>Cache Queries</h4>
    <p>Add queries to ReadySet's in-memory cache</p>
  </a>
  <a href="guides/intro/intro/" class="column">
    <h4>About ReadySet</h4>
    <p>Learn how ReadySet speeds up applications</p>
  </a>
  <a href="reference/sql-support/" class="column">
    <h4>SQL Support</h4>
    <p>Explore the SQL syntax supported by ReadySet</p>
  </a>
</div>
