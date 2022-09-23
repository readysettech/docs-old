# Telemetry

ReadySet collects telemetry data to help us diagnose issues and understand how users interact with our product.

This telemetry data is anonymous by default. Users can opt into providing a persistent identifier, or disable telemetry completely.

Telemetry is reported using the [Segment](https://segment.com) customer data platform.

## Disabling telemetry

Telemetry can be disabled by running ReadySet executables with the `--disable-telemetry` option.

## Providing your own Segment source

By default, ReadySet reports telemetry to an [HTTP Tracking API Source](https://segment.com/docs/connections/sources/catalog/libraries/server/http-api/) operated by ReadySet, Inc. A different source can be specified by setting the `RS_SEGMENT_WRITE_KEY` environment variable to the write key corresponding to the source you wish to use.

## What telemetry data is collected?

Telemetry messages adhere to the [Segment Track API spec](https://segment.com/docs/connections/spec/track/). Each telemetry message contains a per-session anonymous UUID, an event name, a timestamp, and 0 or more properties. If the `RS_API_KEY` environment variable is set, its value will be used as the user ID.

The following OpenAPI schema describes all possible telemetry payloads reported by ReadySet:

```yaml
components:
  schemas:
    TrackBody:
      type: object
      properties:
        userId:
          type: string
          description: the value in the RS_API_KEY env var, if present
        anonymousId:
          type: string
          description: a per-session UUID
        event:
          enum:
            - adapter_start
            - adapter_stop
            - create_cache
            - deployment_finished
            - deployment_started
            - deployment_torn_down
            - installer_finished
            - installer_run
            - query_parse_failed
            - server_start
            - server_stop
            - show_caches
            - show_proxied_queries
            - snapshot_complete
            - upstream_connected
        properties:
          $ref: '#/components/schemas/Properties'
        timestamp:
          type: string
          format: date-time
      required:
        - anonymousId
        - event
        - timestamp
    Properties:
      type: object
      properties:
        adapter_version:
            type: string
        commit_id:
            type: string
        db_backend:
          enum:
            - mysql
            - postgres
        deployment_env:
          enum:
            - eks
            - helm
            - installer_compose
        docker_version:
          type: string
        query_id:
          type: string
        server_version:
          type: string
```

### Events

Below are brief descriptions of each possible event:

- **Server Start**: The ReadySet server was launched
- **Server Stop**: The ReadySet server was shut down
- **Adapter Start**: The ReadySet adapter was launched
- **Adapter Stop**: The ReadySet adapter was shut down
- **Installer Run**: The ReadySet installer was launched
- **Deployment Started**: A deployment of ReadySet was initiated by the installer
- **Deployment Finished**: The ReadySet installer finished deploying a new instance of ReadySet
- **Deployment Torn Down**: The ReadySet installer finished tearing down a deployment
- **Installer Finished**: The ReadySet installer exited successfully
- **Query Parse Failed**: ReadySet failed to parse a query, but the upstream was able to
- **Create Cache**: A CREATE CACHE statement was executed
- **Show Caches**: The SHOW CACHES statement was executed
- **Show Proxied Queries**: The SHOW PROXIED QUERIES statement was executed
- **Snapshot Complete**: ReadySet successfully snapshotted the upstream database
- **Upstream Connected**: ReadySet successfully connected to the upstream database
