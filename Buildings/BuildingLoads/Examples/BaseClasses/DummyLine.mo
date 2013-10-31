within Buildings.BuildingLoads.Examples.BaseClasses;
model DummyLine
  extends Buildings.Electrical.Interfaces.PartialTwoPort(
      redeclare package PhaseSystem_p =
        Buildings.Electrical.PhaseSystems.OnePhase,
      redeclare package PhaseSystem_n =
        Buildings.Electrical.PhaseSystems.OnePhase,
      redeclare
      Buildings.Electrical.AC.ThreePhasesBalanced.Interfaces.Terminal_n           terminal_n,
      redeclare
      Buildings.Electrical.AC.ThreePhasesBalanced.Interfaces.Terminal_n           terminal_p);
///fixme: this model can most likely be removed for the release
  parameter Modelica.SIunits.Distance l(min=0) "Length of the line";
  parameter Modelica.SIunits.Power P_nominal(min=0) "Nominal power of the line";
  parameter Modelica.SIunits.Voltage V_nominal "Nominal voltage of the line";
equation

  connect(terminal_n, terminal_p) annotation (Line(
      points={{-100,2.22045e-16},{-4,2.22045e-16},{-4,0},{100,0}},
      color={0,120,120},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(coordinateSystem(
            preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
          graphics={
          Rectangle(extent={{-80,12},{80,-12}}, lineColor={0,0,0}),
          Line(
            points={{-80,0},{-100,0}},
            color={0,0,0},
            smooth=Smooth.None),
          Line(
            points={{80,0},{100,0}},
            color={0,0,0},
            smooth=Smooth.None),
          Text(
            extent={{-44,70},{40,34}},
            lineColor={0,0,0},
            textString="%name"),
          Text(
            extent={{-104,-36},{104,-78}},
            lineColor={0,0,0},
            textString="l=%l")}));
end DummyLine;
