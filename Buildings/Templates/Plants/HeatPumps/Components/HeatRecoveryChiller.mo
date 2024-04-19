within Buildings.Templates.Plants.HeatPumps.Components;
model HeatRecoveryChiller
  "Heat recovery chiller for sidestream integration"
  Buildings.Templates.Components.Chillers.Compression chi(
    final typ=Buildings.Templates.Components.Types.Chiller.WaterCooled,
    final have_switchover=true)
    "Chiller"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Templates.Plants.HeatPumps.Interfaces.Bus bus "Plant control bus"
    annotation (Placement(transformation(extent={{-20,180},{20,220}}),
        iconTransformation(extent={{-570,-210},{-530,-170}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
    Bitmap(extent={{-20,60},{20,100}}, fileName=
    "modelica://Buildings/Resources/Images/Templates/Components/Boilers/ControllerOnboard.svg"),
    Text( extent={{-60,20},{60,-20}},
          textColor={0,0,0},
          textString="CHI"),
    Rectangle(
          extent={{100,60},{-100,-60}},
          lineColor={0,0,0},
          lineThickness=1)}),                                    Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-200,-200},{200,200}})));
end HeatRecoveryChiller;
