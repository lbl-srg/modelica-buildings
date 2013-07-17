within Districts.Electrical.Interfaces;
partial model PartialCapacitiveLoad
  extends PartialLoad;
  function j = PhaseSystem.j;
  parameter Modelica.SIunits.Voltage V_nominal(min=0) = 0
    "Nominal voltage (V_nominal >= 0)"  annotation(evaluate=true, Dialog(group="Nominal conditions", enable = mode==2));
  parameter Real pf(min=0, max=1) = 0.8 "Power factor"  annotation(evaluate=true,Dialog(group="Nominal conditions"));
  Modelica.SIunits.ElectricCharge q[2](each stateSelect=StateSelect.prefer);
  Modelica.SIunits.Admittance[2] Y;
  Modelica.SIunits.AngularVelocity omega;
end PartialCapacitiveLoad;
