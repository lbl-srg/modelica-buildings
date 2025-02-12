within Buildings.Examples.ChillerPlants.DataCenter.BaseClasses;
model DataCenterContinuousTimeControl
  extends Buildings.Examples.ChillerPlants.DataCenter.ContinuousTimeControl;
  Modelica.Blocks.Interfaces.RealOutput PAC
    "Alternate current power required for IT" annotation (Placement(
        transformation(extent={{-140,-230},{-120,-210}}),
                                                    iconTransformation(extent={{100,40},
            {120,60}})));
  Modelica.Blocks.Interfaces.RealOutput PDC
    "Direct current power required for IT"    annotation (Placement(
        transformation(extent={{-140,-250},{-120,-230}}),
                                                    iconTransformation(extent={{100,-40},
            {120,-20}})));
equation
  connect(PHVAC.y, PAC) annotation (Line(
      points={{-279,-250},{-268,-250},{-268,-220},{-130,-220},{-130,-220}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PIT.y, PDC) annotation (Line(
      points={{-279,-280},{-256,-280},{-256,-228},{-194,-228},{-194,-240},{-130,
          -240}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Icon(graphics={
                  Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Bitmap(extent={{-88,-78},{96,88}},
            fileName=
              "modelica://Buildings/Resources/Images/Examples/ChillerPlant/DataCenter/DataCenter.png")}),
      Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-400,-300},{400,
            300}}), graphics));
end DataCenterContinuousTimeControl;
