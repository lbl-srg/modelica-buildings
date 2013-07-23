within Districts.Electrical.Interfaces;
partial model PartialInductiveLoad
  extends PartialLoad;
  function j = PhaseSystem.j;
  parameter Modelica.SIunits.Voltage V_nominal(min=0, start=220)
    "Nominal voltage (V_nominal >= 0)"  annotation(evaluate=true, Dialog(group="Nominal conditions", enable = mode==2));
  parameter Real pf(min=0, max=1) = 0.8 "Power factor"  annotation(evaluate=true,Dialog(group="Nominal conditions"));
  Modelica.SIunits.MagneticFlux psi[2](each stateSelect=StateSelect.prefer);
  Modelica.SIunits.Impedance Z[2];
  Modelica.SIunits.AngularVelocity omega;
end PartialInductiveLoad;
