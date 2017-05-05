/*
 * @file   bcvtb.h
 *
 * @brief  Methods for interfacing Modelica as
 *         a client to the BCVTB
 *         using BSD sockets.
 *
 * @author Michael Wetter,
 *         Simulation Research Group,
 *         LBNL,
 *         MWetter@lbl.gov
 *
 * @date   2009-05-04
 *
 * This file provides methods that allow a Modelica
 * simulation environment to
 * establish a socket connection. The methods that
 * need to be called are
 * @c establishModelicaClient() at the start of the
 * simulation, and then \c exchangeModelicaClient
 * in each time step. After the simulation,
 * @c closeModelicaClient should be called to close the
 * socket.
 *
 *
 * @sa establishModelicaClient
 * @sa exchangeModelicaClient
 * @sa closeModelicaClient
 *
 */
#ifndef _BCVTB_MODELICA_H_
#define _BCVTB_MODELICA_H_

#include <stddef.h>

/*
 * Establishes a connection to the socket.
 *
 * This method establishes the client socket.
 *
 * @param docname Name of xml file that contains the socket information.
 * @return The socket file descripter, or a negative value if an error occurred.
 */
int establishModelicaClient(const char *const docname);

/*
 * Exchanges data with the socket.
 *
 * Clients can call this method to exchange data through the socket.
 * @param sockfd Socket file descripter
 * @param flaWri Communication flag to write to the socket stream.
 * @param flaRea Communication flag read from the socket stream.
 * @param simTimWri Current simulation time in seconds to write.
 * @param dblValWri Double values to write.
 * @param nDblWri Number of double values to write.
 * @param intValWri Integer values to write.
 * @param nIntWri Number of integer values to write.
 * @param boolValWri Boolean values to write.
 * @param nBooWri Number of boolean values to write.
 * @param simTimRea Current simulation time in seconds read from socket.
 * @param dblValRea Double values read from socket.
 * @param nDblRea Number of double values to read.
 * @param intValRea Integer values read from socket.
 * @param nIntRea Number of integer values to read.
 * @param booValRea Boolean values read from socket.
 * @param nBooRea Number of boolean values to read.
 * @sa int establishclientsocket(uint16_t *portNo)
 * @return The exit value of \c send or \c read, or a negative value if an error occurred.
 */
int exchangeModelicaClient(int sockfd,
			   int flaWri, int *flaRea,
			   double simTimWri,
			   double* dblValWri, size_t nDblWri,
			   double* simTimRea,
			   double* dblValRea, size_t nDblRea);
/*
 * Closes the inter process communication socket.
 *
 * @param sockfd Socket file descripter.
 * @return The return value of the \c close function.
 */
int closeModelicaClient(int sockfd);

#endif /* _BCVTB_MODELICA_H_ */

/*
********************************************************************
Copyright Notice
----------------

Building Controls Virtual Test Bed (BCVTB) Copyright (c) 2008, The
Regents of the University of California, through Lawrence Berkeley
National Laboratory (subject to receipt of any required approvals from
the U.S. Dept. of Energy). All rights reserved.

If you have questions about your rights to use or distribute this
software, please contact Berkeley Lab's Technology Transfer Department
at TTD@lbl.gov

NOTICE.  This software was developed under partial funding from the U.S.
Department of Energy.  As such, the U.S. Government has been granted for
itself and others acting on its behalf a paid-up, nonexclusive,
irrevocable, worldwide license in the Software to reproduce, prepare
derivative works, and perform publicly and display publicly.  Beginning
five (5) years after the date permission to assert copyright is obtained
from the U.S. Department of Energy, and subject to any subsequent five
(5) year renewals, the U.S. Government is granted for itself and others
acting on its behalf a paid-up, nonexclusive, irrevocable, worldwide
license in the Software to reproduce, prepare derivative works,
distribute copies to the public, perform publicly and display publicly,
and to permit others to do so.


Modified BSD License agreement
------------------------------

Building Controls Virtual Test Bed (BCVTB) Copyright (c) 2008, The
Regents of the University of California, through Lawrence Berkeley
National Laboratory (subject to receipt of any required approvals from
the U.S. Dept. of Energy).  All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

   1. Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
   2. Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in
      the documentation and/or other materials provided with the
      distribution.
   3. Neither the name of the University of California, Lawrence
      Berkeley National Laboratory, U.S. Dept. of Energy nor the names
      of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER
OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

You are under no obligation whatsoever to provide any bug fixes,
patches, or upgrades to the features, functionality or performance of
the source code ("Enhancements") to anyone; however, if you choose to
make your Enhancements available either publicly, or directly to
Lawrence Berkeley National Laboratory, without imposing a separate
written license agreement for such Enhancements, then you hereby grant
the following license: a non-exclusive, royalty-free perpetual license
to install, use, modify, prepare derivative works, incorporate into
other computer software, distribute, and sublicense such enhancements or
derivative works thereof, in binary and source code form.

********************************************************************
*/
