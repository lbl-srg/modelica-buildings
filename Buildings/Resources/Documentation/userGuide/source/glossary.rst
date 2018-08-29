Glossary
========

.. glossary::

   2nd order low pass filter
      A second order low pass filter is an input-output block that computes

      .. math::

       \dot x(t) = \begin{pmatrix} r & 0 \\ -r & r \end{pmatrix} \, x(t) + \begin{pmatrix} -r \\ 0 \end{pmatrix} \, u(t)

      and

      .. math::

          y(t) = (0, \, 1) \, x(t),

      where :math:`r` is a positive real number.
      This causes the input signal :math:`u(\cdot)` to be converted to
      an output signal :math:`y(\cdot)` that is differentiable in time.
      See the :ref:`plot of a filtered step response <FigureFilteredResponse>`.

   compressible flow
      The opposite of :term:`incompressible flow`.

   incompressible flow
      In fluid mechanics, incompressible flow refers to flow where the mass
      density is constant within a fluid volume that moves with the fluid.

   iterative solver
      An iterative solver is a numerical solver that iterates until
      the approximate solution satisfies a convergence test.
      Examples include Newton solvers for nonlinear systems of equations,
      and ordinary differential equation solvers with adaptive time step
      length.

   numerical noise
      In numerical solutions, numerical noise refers to fast but small
      changes in variables whose magnitude is typically smaller than
      the solver tolerance.

   regularization
      By regularization, we mean approximating a non-differentiable function by another function that is differentiable and has continuous and bounded derivatives, i.e., a function that is continuously differentiable. Continuous differentiability is a necessary condition for Newton-based solvers to solve nonlinear equations.

   state variables
      State variables are variables whose time rate of change is defined by a differential equation.

   thermo-fluid system
      Thermo-fluid systems are systems that compute combined mass and energy flow, such as a heat exchanger in which heat is added to the medium that flows through it.

   valve authority
      For a control valve, the valve authority :math:`N` is defined as

      .. math::

         N = \frac{\Delta p_v(1)}{\Delta p_v(1) + \Delta p_0},

      where :math:`\Delta p_v(1)` is the pressure drop across the fully open valve, and :math:`\Delta p_v(1) + \Delta p_0` is the pressure drop across the whole flow leg whose mass flow rate is controlled by the valve. Valves should be designed such that :math:`N` is around 0.5, but not higher.
