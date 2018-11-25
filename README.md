# Seeker
Serverless Framework built on elixir

#### Installation
Seeker requires Elixir v1.6 along with PostgreSQL

Update the postgres credentials in `apps/seeker/config/dev.exs`

Run `mix ecto.create`

Run `mix ecto.migrate`

Run `mix phx.server` to start the server

#### Documentation
This project currently has only API based interaction.

Documentation is generated using `ex_doc`.

Run `mix docs` in the project root

You can find the documentation in `doc/index.html`

#### Features
Custom language for writing application logic defined in `Compose.DSL`

Workflow engine for combining multiple components

#### Usage
At the core of `Seeker` is a component.

Component is a simple process which listens to messages on its inports and executes the DSL once all the messages are received and dispatches messages on its outports.

A component definition looks like this:

```json
{
  "component":{
    "name":"adder",
    "code":{
      "type":"=", "arguments":[
        { "type":"var", "arguments":[ { "type":"atom", "arguments": [ "c" ] } ] },
        {
          "type":"+", "arguments":[
              { "type":"var", "arguments":[{ "type":"atom", "arguments":[ "a" ] } ] },
              { "type":"var", "arguments":[{ "type":"atom", "arguments":[ "b" ] } ] }
          ]
        }
      ]
    },
    "inports":[ "a", "b" ],
    "outports":[ "c" ]
  }
}
```
To learn more about component, check [here](https://github.com/spawnfest/factor18/blob/master/apps/seeker/lib/seeker/flow/component.ex).

Once the components are present, a workflow can be generated to link the components to create complex logics.

A workflow is defined using an acyclic graph. The nodes of the graph are the components and the links between them define the connections.

A workflow definition looks like this:
```json
{
  "workflow": {
	"name": "test",
	"params": [ "a", "b" ],
	"nodes": [
	  { "id": 0, "type": "in", "component": "1" },
	  { "id": 1, "type": "out", "component": "1" }
	],
	"edges": [
	  { "source_node": 0, "target_node": 1, "source_port": "c", "target_port": "a" },
      { "source_node": 0, "target_node": 1, "source_port": "c", "target_port": "b" }
    ]
  }
}
```
To learn more about workflow, check [here](https://github.com/spawnfest/factor18/blob/master/apps/seeker/lib/seeker/flow/workflow.ex).

Once the workflow is created, it can be invoked via the API endpoint.

#### Sample API payloads

To create a component use this [CURL](https://github.com/spawnfest/factor18/blob/master/apps/seeker/test/support/curl_commands/create_component.txt)

To create a workflow use this [CURL](https://github.com/spawnfest/factor18/blob/master/apps/seeker/test/support/curl_commands/create_workflow.txt)

To execute a workflow use this [CURL](https://github.com/spawnfest/factor18/blob/master/apps/seeker/test/support/curl_commands/execute_workflow.txt)

#### TODO
- [x] Workflow engine
- [x] Basic DSL
- [ ] Error handling
- [ ] Debugger
- [ ] Extend DSL
- [ ] Distributed support
- [ ] Dynamic route registration
- [ ] Support for long running tasks
- [ ] Finite State Machine
- [ ] Add UI Support

#### NOTE
`Composer` app is inspired by my previous project [Virta](https://github.com/factor18/virta)
