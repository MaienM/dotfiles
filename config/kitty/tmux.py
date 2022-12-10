"""
Kitty kitten to run a kitty command wrapped in tmux passthrough.
"""

from os import environ
from kitty.boss import Boss
import kitty.remote_control


ESCAPE = b'\x1b'
ESCAPE_END = ESCAPE + b'\\'
ENCODE_SEND_ORIGINAL = kitty.remote_control.encode_send


def encode_send_with_tmux_passthrough(*args, **kwargs):
    orig = ENCODE_SEND_ORIGINAL(*args, **kwargs)
    if not orig.startswith(ESCAPE):
        return orig

    return b''.join([
        ESCAPE,
        b'Ptmux;',
        ESCAPE,
        orig.replace(ESCAPE_END, ESCAPE + ESCAPE_END),
        ESCAPE_END,
    ])


def main(args):
    if 'TMUX' in environ:
        kitty.remote_control.encode_send = encode_send_with_tmux_passthrough

    kitty.remote_control.main(args[1:])
