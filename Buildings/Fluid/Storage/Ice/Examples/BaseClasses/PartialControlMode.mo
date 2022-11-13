within Buildings.Fluid.Storage.Ice.Examples.BaseClasses;
partial block PartialControlMode
  "Partial model for closed loop control for ice storage plant"

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput demLev "Demand level" annotation (
    Placement(visible = true, transformation(origin={-260,180},   extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin={-260,200},   extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  Controls.OBC.CDL.Interfaces.BooleanOutput yWatChi "If true, enable water chiller operation" annotation (
    Placement(transformation(extent={{240,0},{280,40}}), iconTransformation(
          extent={{240,0},{280,40}})));
  Controls.OBC.CDL.Interfaces.BooleanOutput yGlyChi "If true, enable glycol chiller operation" annotation (
    Placement(transformation(extent={{240,-40},{280,0}}), iconTransformation(
          extent={{240,-40},{280,0}})));
  Controls.OBC.CDL.Interfaces.BooleanOutput
                                         yStoOn
    "Control signal for storage main leg"
    annotation (Placement(transformation(extent={{240,100},{280,140}}),
        iconTransformation(extent={{240,100},{280,140}})));
  Controls.OBC.CDL.Interfaces.BooleanOutput
                                         yStoByp
    "Control signal for storage bypass leg"
    annotation (Placement(transformation(extent={{240,60},{280,100}}),
        iconTransformation(extent={{240,60},{280,100}})));
  Controls.OBC.CDL.Interfaces.BooleanOutput
                                         yPumSto
    "Pump speed ice storage" annotation (Placement(transformation(extent={{240,-100},
            {280,-60}}), iconTransformation(extent={{240,-100},{280,-60}})));
  Controls.OBC.CDL.Interfaces.BooleanOutput yPumGlyChi
    "Pump speed glycol chiller" annotation (Placement(transformation(extent={{
            240,-140},{280,-100}}), iconTransformation(extent={{240,-142},{280,
            -102}})));
  Controls.OBC.CDL.Interfaces.BooleanOutput
                                         yPumWatChi
                    "Pump speed water chiller"
    annotation (Placement(transformation(extent={{240,-260},{280,-220}}),
        iconTransformation(extent={{240,-260},{280,-220}})));
  Controls.OBC.CDL.Interfaces.BooleanOutput
                                         yPumWatHex
    "Pump speed water-side of heat exchanger" annotation (Placement(
        transformation(extent={{240,-220},{280,-180}}), iconTransformation(
          extent={{240,-220},{280,-180}})));

  annotation (
    Icon(coordinateSystem(preserveAspectRatio = false, extent={{-240,-260},{240,
            240}}),                                                                          graphics={  Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent={{-240,
              240},{240,-260}}),                                                                                                                                                                                       Text(lineColor = {0, 0, 127}, extent={{-50,282},
              {50,238}},                                                                                                                                                                                                        textString = "%name")}),
    Diagram(coordinateSystem(preserveAspectRatio = false, extent={{-240,-260},{240,
            240}})),
    Documentation(info="<html>
<p>
Plant controller for low power mode.
</p>
<p>
Based on the demand level, this controller first runs the water chiller,
and then the glycol plant.
If the ice tank has a sufficient state of charge, it will be discharged,
and afterwards the glycol chiller will be operated to serve the cooling load.
The ice tank will not be charged in this mode.
</p>
</html>", revisions="<html>
<ul>
<li>
November 10, 2022, by Ettore Zanetti:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialControlMode;
