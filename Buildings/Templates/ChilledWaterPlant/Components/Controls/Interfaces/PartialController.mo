within Buildings.Templates.ChilledWaterPlant.Components.Controls.Interfaces;
model PartialController

  outer parameter String id
    "System identifier";
  outer parameter ExternData.JSONFile dat
    "External parameter file";

  parameter Boolean is_airCoo;

  BaseClasses.BusChilledWater busCHW annotation (Placement(transformation(
          extent={{200,-20},{240,20}}), iconTransformation(extent={{80,-20},{
            120,20}})));
  BaseClasses.BusCondenserWater busCon if not is_airCoo annotation (Placement(
        transformation(extent={{-218,-20},{-178,20}}), iconTransformation(
          extent={{-120,-20},{-80,20}})));
  annotation (
    __Dymola_translate=true,
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-151,-114},{149,-154}},
          lineColor={0,0,255},
          textString="%name")}),                                 Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-200,-200},{220,
            200}})));
end PartialController;
