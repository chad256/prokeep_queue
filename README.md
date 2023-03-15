# Prokeep

This application receives messages to add to a queue at the `/receive-message` endpoint.

A separate `Queue` process exists for each queue, and it processes messages at a rate of 1 per second. The state of each queue is stored in ets.

The `QueueTest` verifies that messages are not processed faster than the rate limit for any given queue.


NOTE:
(In a real production use case, the queue state would need to be stored in a database or persistant store outside of the application. In the case the entire application crashes here, all queue state would be lost, even in the ets table.)
