#!/usr/bin/env python
##########################################################################
# This file has been contributed by Joerg Raedler, for release with
# the Modelica Buildings library.
#
#                                                             May 27, 2011
##########################################################################
import scipy.io

_trans = lambda a: [''.join(s).rstrip() for s in zip(*a)]


class DymolaMat:
    """Access result files from dymola"""
    
    def __init__(self, fileName):
        """open the file, parse contents"""
        self.fileName = fileName
        self.mat = scipy.io.loadmat(fileName)
        self._vars = {}
        self._blocks = []
        names = _trans(self.mat['name'])
        descr = _trans(self.mat['description'])
        for i in range(len(names)):
            c = self.mat['dataInfo'][1][i]-1
            d = self.mat['dataInfo'][0][i]
            if c:
                self._vars[names[i]] = (descr[i], d, c)
                if not d in self._blocks:
                    self._blocks.append(d)
            else:
                self._absc = (names[i], descr[i])

    def blocks(self):
        """return numbers of data blocks"""
        return self._blocks

    def names(self, block=None):
        """return the names of all variables (or all of the block)"""
        if block is None:
            return self._vars.keys()
        else:
            return [k for (k,v) in self._vars.items() if v[1] == block]

    def description(self, varName):
        """return the description of a variable"""
        return self._vars[varName][0]

    def abscissa(self, blockOrName):
        """return the values, name and description of the abscissa
        that belongs to a variable or block"""
        try:
            b = int(blockOrName)
        except:
            b = self._vars[blockOrName][1]
        di = 'data_%d' % (b)
        return self.mat[di][0], self._absc[0], self._absc[1]

    def data(self, varName):
        """return the values of a variable"""
        tmp, d, c = self._vars[varName]
        di = 'data_%d' % (d)
        dd = self.mat[di][abs(c)]
        if c < 0:
            dd *= -1
        return dd

    def writeVar(self, varName):
        """write the values of a variable and its abscissa to stdout"""
        d = self.data(varName)
        a, aname, tmp = self.abscissa(varName)
        print '# %s | %s' % (aname, varName)
        for i in range(d.shape[0]):
            print '%f %g' % (a[i], d[i])


if __name__ == '__main__':
    import sys
    dm = DymolaMat(sys.argv[1])
    if len(sys.argv) < 3:
        for n in dm.names():
            print n
    else:
        dm.writeVar(sys.argv[2])
