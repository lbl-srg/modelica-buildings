Glossary
========

.. glossary::

   2nd order low pass filter
      A second order low pass filter is an input-output block that computes
      :math:`\dot x(t) = A \, x(t) + (-1, 0)^T \, u(t)` and 
      :math:`y(t) = (0, \, 1) \, x(t)`,
      where :math:`A = (r, \, 0; \, -r, \, r)` with :math:`r` being a positive
      real number. 
      This causes the input signal :math:`u(\cdot)` to be converted to 
      an output signal :math:`y(\cdot)` that is differentiable in time.
      See the :ref:`plot of a filtered step response <FigureFilteredResponse>`. 
 
   numerical noise
      In numerical solutions, numerical noise refers to fast but small
      changes in variables whose magnitude is typically smaller than
      the solver tolerance.

   incompressible flow
      In fluid mechanics, incompressible flow refers to flow where the mass
      density is constant within a fluid volume that moves with the fluid.

   compressible flow
      The opposite of :term:`incompressible flow`.

   thermo-fluid system
      Thermo-fluid systems are systems that compute combined mass and energy flow, such as a heat exchanger in which heat is added to the medium that flows through it.

   state variables
      State variables are variables whose time rate of change is defined by a differential equation.
