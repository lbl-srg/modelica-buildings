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

import numpy, scipy.io

# extract strings from the matrix
_trans = lambda a: [''.join(s).rstrip() for s in zip(*a)]


class DyMatFile:
    """A result file written by Dymola or OpenModelica"""

    def __init__(self, fileName):
        """Open the file, parse contents"""
        self.fileName = fileName
        self.mat = scipy.io.loadmat(fileName)
        self._vars = {}
        self._blocks = []
        names = _trans(self.mat['name']) # names
        descr = _trans(self.mat['description']) # descriptions
        for i in range(len(names)):
            d = self.mat['dataInfo'][0][i] # data block
            x = self.mat['dataInfo'][1][i]
            c = abs(x)-1  # column
            s = cmp(x, 0) # sign
            if c:
                self._vars[names[i]] = (descr[i], d, c, s)
                if not d in self._blocks:
                    self._blocks.append(d)
            else:
                self._absc = (names[i], descr[i])

    def block(self, varName):
        """Return numbers of data block which contains variable"""
        return self._vars[varName][1]

    def blocks(self):
        """Return numbers of data blocks"""
        return self._blocks

    def names(self, block=None):
        """Return the names of all variables (or all of the block)"""
        if block is None:
            return self._vars.keys()
        else:
            return [k for (k,v) in self._vars.items() if v[1] == block]

    def description(self, varName):
        """Return the description of a variable"""
        return self._vars[varName][0]

    def sharedData(self, varName):
        """Return variables which share data with this variable, possibly with
        a different sign."""
        tmp, d, c, s = self._vars[varName]
        return [(n,v[3]*s) for (n,v) in self._vars.items() if n!=varName and v[1]==d and v[2]==c]

    def nameTree(self):
        """Return a name tree of all variables"""
        root = {}
        for v in self._vars.keys():
            branch = root
            elem = v.split('.')
            for e in elem[:-1]:
                if not e in branch:
                    branch[e] = {}
                branch = branch[e]
            branch[elem[-1]] = v
        return root

    def block(self, varName):
        """Return data block which contains the variable"""
        return self._vars[varName][1]

    def sortByBlocks(self, varList):
        """Return dictionary with variables in varList sorted by the block number"""
        vl = [(v, self._vars[v][1]) for v in varList]
        vDict = {}
        for bl in self._blocks:
            l = [v for v,b in vl if b==bl]
            if l:
                vDict[bl] = l
        return vDict

    def size(self, blockOrName):
        """Return the number of rows of a variable or block"""
        try:
            b = int(blockOrName)
        except:
            b = self._vars[blockOrName][1]
        di = 'data_%d' % (b)
        return self.mat[di].shape[1]

    def abscissa(self, blockOrName, valuesOnly=False):
        """Return the values, name and description of the abscissa
        that belongs to a variable or block. If valuesOnly is true, only
        the values are returned."""
        try:
            b = int(blockOrName)
        except:
            b = self._vars[blockOrName][1]
        di = 'data_%d' % (b)
        if valuesOnly:
            return self.mat[di][0]
        else:
            return self.mat[di][0], self._absc[0], self._absc[1]

    def data(self, varName):
        """Return the values of a variable"""
        tmp, d, c, s = self._vars[varName]
        di = 'data_%d' % (d)
        dd = self.mat[di][c]
        if s < 0:
            dd *= -1
        return dd

    def getVarArray(self, varNames, withAbscissa=True):
        """Return the values of all variables in varNames combined as a
        2d-array, all variables must share the same block. If withAbscissa is
        True, include abscissa's values first."""
        # FIXME: check blocks!
        v = [numpy.array(self.data(n), ndmin=2) for n in varNames]
        if withAbscissa:
            v.insert(0, numpy.array(self.abscissa(varNames[0], True), ndmin=2))
        return numpy.concatenate(v, 0)

    def writeVar(self, varName):
        """Write the values of a variable and its abscissa to stdout"""
        d = self.data(varName)
        a, aname, tmp = self.abscissa(varName)
        print('# %s | %s' % (aname, varName))
        for i in range(d.shape[0]):
            print('%f %g' % (a[i], d[i]))


# for compatibility with old versions
DymolaMat = DyMatFile

