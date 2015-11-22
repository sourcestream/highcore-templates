Highcore stack template
=======================

Configure highcore to deploy itself from this template.

template.sh is the entry point, it must be called with the following parameters:

|Parameter|Description|
|:---|:---|
| template_path | Path to the template directory |
| template | Name of the stack template |
| stack_definition | JSON-encoded stack definition |

Templates
=========

env
---
components: security, vpc, subnet, private_zone

highcore
--------
components: api, ui


