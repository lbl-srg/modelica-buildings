within Buildings.Templates.HeatingPlants.HotWater.Validation.UserProject;
block AirHandlerControlPoints
  "Emulation of AHU control points"
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
  Controls.OBC.CDL.Integers.Sources.Constant reqHeaWatRes(k=0)
    "HW reset request"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Controls.OBC.CDL.Integers.Sources.Constant reqHeaWatPla(k=1)
    "HW plant request"
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
equation
  connect(reqHeaWatRes.y, bus.reqHeaWatRes) annotation (Line(points={{12,0},{
          100,0}}, color={255,127,0}));
  connect(reqHeaWatPla.y, bus.reqHeaWatPla) annotation (Line(points={{12,-40},{
          80,-40},{80,0},{100,0}}, color={255,127,0}));
  annotation (Documentation(info="<html>
<p>
This class generates signals typically provided by the AHU controller. 
It is aimed for validation purposes only.
</p>
</html>"));
end AirHandlerControlPoints;
