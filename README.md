# MiddleGround

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

# Your assumptions and technical design considerations for the prototype
Tackled the prompt of Encouraging aisle-crossing with a bit of a twist. Modeled the app idea after a series of youtube videos called Middle Ground where particpants are in small groups asked to choose how they agree with a statement and then converse about it. 

Given the (self-imposed) requirements of working real time chat, used elixir (phoenix framework) as it has out of the box support for accounts, and live view is basically tailor made for real time applications. Uses channels/sockets to allow for continuous updates of client and easy streaming of data. 

Drawback is that some client things become a bit harder, given templates have to call raw js via hooks. Could eventually tie into component libraries but haven't played around with that. 

The design originally called for video chat, but wasn't time for that.

# Where you got to in the prototype—constraints, challenges, observations, and remaining explorations you might have wanted to try with more time and resources

Mostly working implementation. Biggest challenge was adding some of they hooks to make nice frontend things happen like loading more messages as you scroll up. 

In general, with more time, I'd probably try to improve on the UI. Specifically would want to display the responses once a user was in the chat. Maybe via a heatmap or something. Was too much work to try to attempt given time available and the tooling.

# What app metrics would be useful to drive user-based insights and how might instrument the app to collect them

To ensure actual conversation and not just posting you're optimizing for time spent reading. You'd likely want to measure how many messages were spent and intervals between them to ensure people are actually reading what each other say. You'd ideally also run some sort of sentient analysis engine on the chat. This would help with moderation but also be a useful tool for examining what topics trigged the most passion and division.  

# NOTES
- There is an admin account which can be used to create new questions/statements
- The url for the admin dashboard is https://middle-ground.fly.dev/admin/questions
- The admin details are located in priv/repo/seeds.ex
