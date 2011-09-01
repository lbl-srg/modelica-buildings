#!/usr/bin/env python

# Copyright (c) 2011, Joerg Raedler (Berlin, Germany)
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without modification,
# are permitted provided that the following conditions are met:
#
# Redistributions of source code must retain the above copyright notice, this list
# of conditions and the following disclaimer. Redistributions in binary form must
# reproduce the above copyright notice, this list of conditions and the following
# disclaimer in the documentation and/or other materials provided with the
# distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
# ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
# ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

import sys, argparse, DyMat

arg = argparse.ArgumentParser()

grp = arg.add_mutually_exclusive_group(required=True)

grp.add_argument('-i', '--info', action='store_true', help='show some information on the file')
grp.add_argument('-l', '--list', action='store_true', help='list variables')
grp.add_argument('-d', '--descriptions', action='store_true', help='list variables with descriptions')
grp.add_argument('-t', '--tree', action='store_true', help='list variables as name tree')
grp.add_argument('-s', '--shared-data', nargs=1, metavar='VAR', help='list connections of variable')
grp.add_argument('-m', '--list-formats', action='store_true', help='list supported export formats')
grp.add_argument('-e', '--export', nargs=1, metavar='VARLIST', help='export these variables')
grp.add_argument('-x', '--export-file', nargs=1, metavar="FILE", help='export variables listed in this file')

arg.add_argument('-o', '--outfile', nargs=1, help='write exported data to this file')
arg.add_argument('-f', '--format', nargs=1, help='export data in this format')
arg.add_argument('-p', '--options', nargs=1, help='export options specific to export format')

arg.add_argument('matfile', nargs=1, help='MAT-file')

pargs = arg.parse_args()

dm = DyMat.DyMatFile(pargs.matfile[0])

if pargs.info:
    blocks = dm.blocks()
    blocks.sort()
    for b in blocks:
        print('Block %02d:' % b)
        s = dm.mat['data_%d' % (b)].shape
        v = len(dm.names(b))
        print('  %d variables point to %d columns with %d timesteps' % (v, s[0]-1, s[1]))

elif pargs.list:
    for n in dm.names():
        print(n)

elif pargs.descriptions:
    nn = dm.names()
    nlen = max((len(n) for n in nn))
    for n in dm.names():
        print("%s | %02d | %s" % (n.ljust(nlen), dm.block(n), dm.description(n)))

elif pargs.tree:
    t = dm.nameTree()
    def printBranch(branch, level):
        if level > 0:
            tmp = '  |'*level+'--'
        else:
            tmp = '--'
        for elem in branch:
            sub = branch[elem]
            if isinstance(sub, dict):
                print(tmp+elem)
                printBranch(sub, level+1)
            else:
                print('%s%s (%s)' % (tmp, elem, sub))
    printBranch(t, 0)

elif pargs.shared_data:
    v = pargs.shared_data[0]
    sd = dm.sharedData(v)
    if sd:
        print(v)
        for n, s in sd:
            print('    = % 2d * %s%s' % (s, n))

# FIXME: this should work without providing a filename
elif pargs.list_formats:
    import DyMat.Export
    for n in DyMat.Export.formats:
        print('%s : %s' % (n, DyMat.Export.formats[n]))

else: # pargs.export or pargs.export_file
    if pargs.export:
        varList = [v.strip() for v in pargs.export[0].split(',')]
    else:
        varList = [l.split('|')[0].strip() for l in open(pargs.export_file[0], 'r') if l]
    if pargs.outfile:
        outFileName = pargs.outfile[0]
    else:
        outFileName = None
    options = {}
    if pargs.options:
        tmp = [v.strip().split('=') for v in pargs.export[0].split(',')]
        for x in tmp:
            options[x[0]] = x[1]
    import DyMat.Export
    if pargs.format:
        fmt = pargs.format[0]
    else:
        fmt = 'CSV'
    DyMat.Export.export(fmt, dm, varList, outFileName, options)
