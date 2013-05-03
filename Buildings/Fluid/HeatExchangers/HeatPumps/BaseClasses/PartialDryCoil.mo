within Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses;
block PartialDryCoil "Partial dry coil condition"
  replaceable package Medium =
      Modelica.Media.Interfaces.PartialCondensingGases "Medium model"
      annotation (choicesAllMatching=true);
  Modelica.Blocks.Interfaces.RealInput XIn "Inlet air mass fraction"
    annotation (Placement(transformation(extent={{-120,-60},{-100,-40}})));
  Modelica.Blocks.Interfaces.RealInput p "Pressure at inlet of coil"
    annotation (Placement(transformation(extent={{-120,-34},{-100,-14}})));
  Modelica.Blocks.Interfaces.RealInput hIn
    "Specific enthalpy of air entering the coil"
            annotation (Placement(transformation(extent={{-120,-87},{-100,-67}})));
  Modelica.Blocks.Interfaces.RealOutput TDry(
    quantity="Temperature",
    unit="K",
    min=233.15,
    max=373.15) "Dry bulb temperature of air at ADP"
     annotation (Placement(transformation(extent={{100,-70},{120,-50}})));
  Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses.ApparatusDryPoint appDryPt
    "Calculates air properties at dry coil condition"
    annotation (Placement(transformation(extent={{40,-70},{60,-50}})));
equation
  connect(hIn, appDryPt.hIn)  annotation (Line(
      points={{-110,-77},{-80,-77},{-80,-68},{39,-68}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(XIn, appDryPt.XIn)  annotation (Line(
      points={{-110,-50},{-80,-50},{-80,-65},{39,-65}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(p, appDryPt.p)  annotation (Line(
      points={{-110,-24},{-76,-24},{-76,-62},{39,-62}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(appDryPt.TDry, TDry) annotation (Line(
      points={{61,-60},{110,-60}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(graphics));
end PartialDryCoil;
