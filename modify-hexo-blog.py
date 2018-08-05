#!/usr/bin/python3
# -*- coding:utf-8 -*-
# 用正则表达式来批量修改博客文件的内容
import sys
import os
import io
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
import re

def odd_repl(match):
    """
    double a match (all of the matched text) when the length of the 
    matched text is odd
    """
    count[0] += 1
    odd_sub = '<pre><code class="language-bash" line-numbers>'
    even_sub = '</code></pre>'
    return odd_sub if count[0]%2 == 1 else even_sub

global count
count = [0]
fileName = sys.argv[1]
with open(fileName, 'r', encoding='utf-8') as f:
    pattern = re.compile(r'```')
    result_new = re.sub(pattern, odd_repl, f.read())

    fp = open(fileName + 'temp', 'w', encoding='utf-8')
    fp.write(result_new)
    fp.close()

    if os.path.exists(fileName):
        os.remove(fileName)
    # rename the temp file
    os.rename(fileName + 'temp', fileName)

           
print("任务已完成")
