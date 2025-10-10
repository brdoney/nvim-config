from collections.abc import Iterator
import numpy as np

# NOTE: Script for converting a translucent color on top of an opaque one into
# an opaque color (i.e. the top color tinted by the bottom color)
# This is helpful for figuring out colors for virtual_text with translucent
# colors, which don't allow `blend` in highlight groups normally


def windows(s: str) -> Iterator[str]:
    for i in range(1, len(s), 2):
        yield s[i : i + 2]


def color(hex: str):
    hex_list = [int(x, base=16) for x in windows(hex)]
    return np.array(hex_list, dtype=np.uint8)


colors = [
    color(c)
    for c in (
        "#ff6d7e",
        "#ffb270",
        "#ffed72",
        "#a2e57b",
        "#7cd5f1",
        "#baa0f8",
    )
]

# For dim colors (unfocused indent guides)
# alpha = int("3f", base=16) / 255
# For bright colors (focused scope)
alpha = int("9f", base=16) / 255

# Background color we're over top of
bg = color("#273136")

for c in colors:
    real = (c * alpha) + (bg * (1 - alpha))
    parts = "".join(hex(round(x))[2:] for x in real)  # pyright: ignore[reportAny]
    print(f"#{parts}")
