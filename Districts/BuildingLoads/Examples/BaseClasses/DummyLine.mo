within Districts.BuildingLoads.Examples.BaseClasses;
model DummyLine
  extends Districts.Electrical.Interfaces.PartialTwoPort(
      redeclare package PhaseSystem_p =
        Districts.Electrical.PhaseSystems.ThreePhase_dq,
      redeclare package PhaseSystem_n =
        Districts.Electrical.PhaseSystems.ThreePhase_dq,
      redeclare Districts.Electrical.AC.AC3ph.Interfaces.Terminal_n terminal_n,
      redeclare Districts.Electrical.AC.AC3ph.Interfaces.Terminal_n terminal_p);

  parameter Modelica.SIunits.Distance l(min=0) "Length of the line";
  parameter Modelica.SIunits.Power P_nominal(min=0) "Nominal power of the line";
  parameter Modelica.SIunits.Voltage V_nominal "Nominal voltage of the line";
  parameter Districts.Electrical.Transmission.Cables.Cable cable=
      Districts.Electrical.Transmission.Functions.selectCable(
        P=P_nominal,
        V=V_nominal,
        mode=Districts.Electrical.Types.CableMode.automatic) "Type of cable"
  annotation (choicesAllMatching=true,Dialog(tab="Tech. specification"), Placement(transformation(extent={{20,60},
              {40,80}})));
  parameter Districts.Electrical.Transmission.Materials.Material wireMaterial=
      Districts.Electrical.Transmission.Materials.Copper()
    "Material of the cable"
    annotation (choicesAllMatching=true,Dialog(tab="Tech. specification"), Placement(transformation(extent={{60,60},
              {80,80}})));
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
