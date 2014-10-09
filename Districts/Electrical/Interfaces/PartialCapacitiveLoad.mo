within Districts.Electrical.Interfaces;
partial model PartialCapacitiveLoad
  extends PartialLoad;
  function j = PhaseSystem.j;
  parameter Real pf(min=0, max=1) = 0.8 "Power factor"  annotation(evaluate=true,Dialog(group="Nominal conditions"));
  Modelica.SIunits.ElectricCharge q[2](each stateSelect=StateSelect.prefer)
    "Electric charge";
  Modelica.SIunits.Admittance[2] Y "Admittance";
  Modelica.SIunits.AngularVelocity omega "Angular velocity";
protected
  Modelica.SIunits.Power Q = P*tan(-acos(pf));
end PartialCapacitiveLoad;
