within Buildings.Controls.OBC.DemandFlexibility.Generic.Validation;
model GeneralModeSelectionBool
  extends Modelica.Icons.Example;
  Buildings.Controls.OBC.DemandFlexibility.Generic.GeneralModeSelectionBool
    generalModeSelectionBool
    annotation (Placement(transformation(extent={{32,-4},{56,20}})));
  CDL.Integers.Sources.TimeTable intTimTab(
    table=[0,0; 16,1; 21,2; 22,0; 24,0],
    timeScale=3600,
    period=86400)
    annotation (Placement(transformation(extent={{-84,36},{-64,56}})));
  CDL.Logical.Sources.Pulse booPul(period=86400)
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  CDL.Logical.Sources.Pulse booPul1(
    width=0.25,
    period=43200,
    shift=32400)
    annotation (Placement(transformation(extent={{-28,-54},{-8,-34}})));
equation
  connect(intTimTab.y[1], generalModeSelectionBool.uMod) annotation (Line(
        points={{-62,46},{-40,46},{-40,16.8},{29.913,16.8}}, color={255,127,0}));
  connect(booPul1.y, generalModeSelectionBool.uReb) annotation (Line(points={{
          -6,-44},{12,-44},{12,0.2},{29.913,0.2}}, color={255,0,255}));
  connect(booPul.y, generalModeSelectionBool.uShe) annotation (Line(points={{
          -18,-10},{6,-10},{6,4.8},{29.913,4.8}}, color={255,0,255}));
   annotation (experiment(
      StopTime=172800,
      Interval=60,
      __Dymola_Algorithm="Dassl"));
end GeneralModeSelectionBool;
