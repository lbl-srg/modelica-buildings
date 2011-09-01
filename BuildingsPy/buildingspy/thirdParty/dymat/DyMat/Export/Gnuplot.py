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


def export(dm, varList=None, fileName=None, formatOptions=None):
    """Export DyMat data to files readable by gnuplot"""

    if not fileName:
        fileName = dm.fileName+'.gpd'


    vList = dm.sortByBlocks(varList)
    if len(vList) > 1:
        raise Exception("Variables have different blocks - can't export to Gnuplot format!")
    else:
        varList = vList[vList.keys[0]]

    nd = [(n, dm.description(n)) for n in varList]
    nd.insert(0, dm._absc)

    oFile = open(fileName, 'w')

    oFile.write('### file generated with DyMat from %s\n' % dm.fileName)
    for i in range(len(nd)):
        n, d = nd[i]
        oFile.write('# %3i %s - %s\n' % (i+1, n, d))

    vData = dm.getVarArray(varList)

    for i in range(vData.shape[1]):
        oFile.write('\t'.join(['%g'%v for v in vData[:,i]]) + '\n')

    oFile.close()
