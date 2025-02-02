import asyncio
from kutana import Kutana, Context
from kutana.backends import Debug


def make_kutana_no_run(backend_source=None):
    app = Kutana()

    debug = Debug(messages=[])

    if backend_source:
        debug.get_identity = lambda: backend_source

    app.add_backend(debug)

    async def _handle_update(update):
        ctx = await Context.create(
            app=app,
            config={
                "prefixes": (".",),
                "mention_prefix": ("",),
                "ignore_initial_spaces": True
            },
            update=update,
            backend=debug
        )

        return await app._handle_update(update, ctx)

    def handle_update(update):
        return app.get_loop().run_until_complete(_handle_update(update))

    return app, debug, handle_update


def make_kutana(messages):
    app = Kutana()

    debug = Debug(
        messages=messages,
        on_complete=app.stop,
    )

    app.add_backend(debug)

    return app, debug


def sync(coro):
    return asyncio.get_event_loop().run_until_complete(coro)
