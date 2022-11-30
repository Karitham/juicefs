#!/usr/bin/env python
# -*- encoding: utf-8 -*-
import os
import re


def get_disable_mutators(enable_mutator_str):
    enable_mutators = [m.strip() for m in enable_mutator_str.split(',')]
    all_mutators = ['branch/case','branch/else','branch/if','expression/comparison','expression/remove','statement/remove']
    for m in enable_mutators:
        if m in all_mutators:
            all_mutators.remove(m)
    return all_mutators

if __name__ == '__main__':
    enable_mutator_str = os.environ['ENABLE_MUTATORS']
    disable_mutators = get_disable_mutators(enable_mutator_str)
    disable_mutators = ['--disable='+m for m in disable_mutators]
    print(' '.join(disable_mutators))
    