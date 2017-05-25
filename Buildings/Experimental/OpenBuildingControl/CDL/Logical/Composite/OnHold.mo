within Buildings.Experimental.OpenBuildingControl.CDL.Logical.Composite;
model OnHold

  Buildings.Experimental.OpenBuildingControl.CDL.Interfaces.BooleanOutput y
    annotation (Placement(transformation(extent={{280,-10},{300,10}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Logical.Less les1
    annotation (Placement(transformation(extent={{-160,-40},{-140,-20}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Constant Zero(k=0)
    annotation (Placement(transformation(extent={{-280,130},{-260,150}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Constant timeOn(k=3600)
    annotation (Placement(transformation(extent={{-280,70},{-260,90}})));
  Or3                                                       or2
    annotation (Placement(transformation(extent={{60,0},{80,20}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Logical.Or  and1
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Logical.And and3
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Logical.Timer timer
    annotation (Placement(transformation(extent={{208,-58},{228,-38}})));

  Buildings.Experimental.OpenBuildingControl.CDL.Logical.And and5
    annotation (Placement(transformation(extent={{-102,-40},{-82,-20}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Logical.And and2
    annotation (Placement(transformation(extent={{66,-94},{86,-74}})));
  Interfaces.BooleanInput u
    annotation (Placement(transformation(extent={{-320,-20},{-280,20}})));
  Modelica.Blocks.Logical.Pre pre
    annotation (Placement(transformation(extent={{160,-94},{180,-74}})));
  Not not1
    annotation (Placement(transformation(extent={{-160,-100},{-140,-80}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Logical.Equal equ1
    annotation (Placement(transformation(extent={{-240,-120},{-220,-100}})));
equation
  connect(or2.y, y) annotation (Line(points={{81,10},{140,10},{140,0},{290,0}},
        color={255,0,255}));
  connect(timer.y, les1.u1) annotation (Line(points={{229,-48},{240,-48},{240,
          -66},{240,-66},{-182,-66},{-182,-30},{-180,-30},{-162,-30}},
                                                           color={0,0,127}));
  connect(les1.y, and5.u1) annotation (Line(points={{-139,-30},{-104,-30}},
                  color={255,0,255}));
  connect(or2.y, and2.u2) annotation (Line(points={{81,10},{120,10},{120,-40},{
          48,-40},{48,-92},{64,-92}},
                          color={255,0,255}));
  connect(u, and1.u1) annotation (Line(points={{-300,0},{-160,0},{-160,-10},{
          -42,-10}}, color={255,0,255}));
  connect(u, and3.u2) annotation (Line(points={{-300,0},{-140,0},{-140,42},{-62,
          42}}, color={255,0,255}));

  connect(timeOn.y, les1.u2) annotation (Line(points={{-259,80},{-260,80},{-256,
          80},{-210,80},{-210,-38},{-162,-38}}, color={0,0,127}));
  connect(and5.y, and1.u2) annotation (Line(points={{-81,-30},{-66,-30},{-66,
          -18},{-42,-18}}, color={255,0,255}));
  connect(and2.y, pre.u)
    annotation (Line(points={{87,-84},{87,-84},{158,-84}}, color={255,0,255}));
  connect(timer.u, pre.y) annotation (Line(points={{206,-48},{194,-48},{194,-84},
          {181,-84}}, color={255,0,255}));
  connect(and5.u2, not1.y) annotation (Line(points={{-104,-38},{-126,-38},{-126,
          -90},{-139,-90}}, color={255,0,255}));
  connect(Zero.y, equ1.u1) annotation (Line(points={{-259,140},{-254,140},{-254,
          -110},{-242,-110},{-242,-110}}, color={0,0,127}));
  connect(timer.y, equ1.u2) annotation (Line(points={{229,-48},{252,-48},{252,
          -140},{252,-140},{-254,-140},{-254,-138},{-254,-118},{-242,-118}},
        color={0,0,127}));
  connect(equ1.y, not1.u) annotation (Line(points={{-219,-110},{-190,-110},{
          -190,-90},{-162,-90}}, color={255,0,255}));
  connect(equ1.y, and3.u1) annotation (Line(points={{-219,-110},{-200,-110},{
          -200,50},{-132,50},{-62,50}}, color={255,0,255}));
  connect(les1.y, and2.u1) annotation (Line(points={{-139,-30},{-120,-30},{-120,
          -84},{-12,-84},{64,-84}}, color={255,0,255}));
  connect(and3.y, or2.u1) annotation (Line(points={{-39,50},{8,50},{8,18},{58,
          18}}, color={255,0,255}));
  connect(and1.y, or2.u3) annotation (Line(points={{-19,-10},{20,-10},{20,2},{
          58,2}}, color={255,0,255}));
  connect(u, or2.u2) annotation (Line(points={{-300,0},{-120,0},{-120,10},{58,
          10}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-280,
            -240},{280,240}})),                                  Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-280,-240},{280,240}})),
              Documentation(info="<html>
    <p>
    Block that holds an on signal for a defined time period.
    </p>
    <p>
    A rising edge of the Boolean input <code>u</code> starts a timer and
    the Boolean output <code>y</code> output stays true until the time
    period provided as a parameter has elapsed. After that
    the block evaluates the Boolean input <code>u</code> and if the input is true,
    the timer gets started again, but if the input is false, the output is also
    false. If the output value is false, it will become true with the first rising
    edge of the inputs signal.
    </p>

    <p>
    fixme - Simulation results of a typical example with a hold time of [fixme]
    is shown in the next figure.
    </p>

    <p align=\"center\">
    <img src=\"modelica://Buildings/Resources/Images/Experimental/OpenBuildingControl/CDL/Logical/fixme.png\"
         alt=\"fixme.png\" />
    </p>

    </html>", revisions="<html>
    <ul>
    <li>
    May 24, 2017, by Milica Grahovac:<br/>
    First implementation.
    </li>
    </ul>
    </html>"));
end OnHold;
