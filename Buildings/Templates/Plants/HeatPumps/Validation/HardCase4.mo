within Buildings.Templates.Plants.HeatPumps.Validation;
model HardCase4 "Validation of AWHP plant template"
  extends Buildings.Templates.Plants.HeatPumps.Validation.AirToWaterReversiblePolyvalent(
    pla(linearized=false,
      typDis_select1=Buildings.Templates.Plants.HeatPumps.Types.Distribution.Constant1Variable2,
      typArrPumPri_select=Buildings.Templates.Components.Types.PumpArrangement.Dedicated,
      typPumPri_select=Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Constant,
      have_pumPriDedComHp_select=false,
      ctl(have_senTPriRet_select=true,
        have_senDpHeaWatRemWir=true)))
     annotation(IconMap(primitivesVisible = false));
annotation(experiment(StopTime=86400,
  Tolerance=1e-06,
  __Dymola_Algorithm="Cvode"),
    Documentation(info="Integration terminated successfully at T = 86400
   CPU-time for integration                  : 7.75864 seconds
   CPU-time for initialization               : 0.430361 seconds
   Number of result points                   : 2127
   Number of grid points                     : 501
   Number of accepted steps                  : 19001
   Number of rejected steps                  : 609
   Number of f-evaluations (dynamics)        : 29171
   Number of non-linear iteration            : 27289
   Number of non-linear convergence failures : 927
   Number of Jacobian-evaluations            : 1601
   Number of crossing function evaluations   : 22998
   Number of model time events               : 475
   Number of state events                    : 340
   Number of step events                     : 0
   Maximum integration order                 : 5

SUCCESSFUL simulation of Buildings.Templates.Plants.HeatPumps.Validation.HardCase4



---------------------------------------------------------------------------
CVodeError                                Traceback (most recent call last)
File /mnt/home/reituag/gitrepo/docker-ubuntu-optimica/jmodelica.py:113
    109     mod.set('_log_level', 4)
    111 ######################################################################
    112 # Simulate
--> 113 res = mod.simulate(options=opts)
    114 #        logging.error(traceback.format_exc())
    116 if generate_plot:

File src/pyfmi/fmi2.pyx:4809, in pyfmi.fmi2.FMUModelME2.simulate()

File src/pyfmi/fmi_base.pyx:214, in pyfmi.fmi_base.ModelBase._exec_simulate_algorithm()

File /opt/OCT/P538-OCT/../install/Python/pyfmi/fmi_algorithm_drivers.py:672, in solve(self)

File assimulo/ode.pyx:192, in assimulo.ode.ODE.simulate()

File assimulo/ode.pyx:312, in assimulo.ode.ODE.simulate()

File assimulo/explicit_ode.pyx:137, in assimulo.explicit_ode.Explicit_ODE._simulate()

File assimulo/explicit_ode.pyx:222, in assimulo.explicit_ode.Explicit_ODE._simulate()

File assimulo/solvers/sundials.pyx:2112, in assimulo.solvers.sundials.CVode.integrate()

File assimulo/solvers/sundials.pyx:2147, in assimulo.solvers.sundials.CVode.integrate()

CVodeError: 'The rootfinding function failed in an unrecoverable manner. At time 32197.144159.'"),
    Icon(graphics={
        Polygon(lineColor = {0,0,255},
                fillColor={0,140,72},
                pattern = LinePattern.None,
                fillPattern=FillPattern.Solid,
                points={{-80,100},{20,40},{-80,-20},{-80,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor={238,46,47},
                pattern = LinePattern.None,
                fillPattern=FillPattern.Solid,
                points={{0,20},{100,-40},{0,-100},{0,20}})}));
end HardCase4;
