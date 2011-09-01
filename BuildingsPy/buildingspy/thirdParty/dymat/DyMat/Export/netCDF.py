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

import scipy.io.netcdf

def export(dm, varList=None, fileName=None, formatOptions=None):
    """Export DyMat data to a netCDF file"""

    if not fileName:
        fileName = dm.fileName+'.nc'

    ncFile = scipy.io.netcdf.netcdf_file(fileName, 'w')
    ncFile.comment = 'file generated with DyMat from %s' % dm.fileName

    vList = dm.sortByBlocks(varList)
    for block in vList:
        a, aname, adesc = dm.abscissa(block)
        dim = '%s_%02i' % (aname, block)
        ncFile.createDimension(dim, a.shape[0])
        av = ncFile.createVariable(dim, 'd', (dim,))
        av.description = adesc
        av.block = block
        av[:] = a
        for vn in vList[block]:
            v = ncFile.createVariable(vn, 'd', (dim,))
            v.description = dm.description(vn)
            v.block = block
            v[:] = dm.data(vn)
