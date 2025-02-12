within Buildings.Templates.Plants.Chillers.Validation.UserProject;
block AirHandlerControlPoints "Emulation of VAV box control points"
  extends Modelica.Blocks.Icons.Block;

  Buildings.Templates.AirHandlersFans.Interfaces.Bus bus
    "AHU control bus"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={100,0}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={100,0})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant reqResChiWat(k=0)
    "CHW reset request"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant reqPlaChiWat(k=1)
    "CHW plant request"
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
equation
  connect(reqResChiWat.y, bus.reqResChiWat) annotation (Line(points={{12,0},{
          100,0}}, color={255,127,0}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(reqPlaChiWat.y, bus.reqPlaChiWat) annotation (Line(points={{12,-40},{
          80,-40},{80,0},{100,0}}, color={255,127,0}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  annotation (Documentation(info="<html>
<p>
This class generates signals typically provided by the AHU controller. 
It is aimed for validation purposes only.
</p>
</html>"));
end AirHandlerControlPoints;
