within Buildings.Experimental.OpenBuildingControl.CDL.Logical.Composite;
model OnHold

  Less                                                        les1
    annotation (Placement(transformation(extent={{-160,-40},{-140,-20}})));
  Continuous.Constant Zero(k=0)
    annotation (Placement(transformation(extent={{-280,130},{-260,150}})));
  Continuous.Constant                                                timeOn(k=3600)
    annotation (Placement(transformation(extent={{-280,70},{-260,90}})));
  Timer                                                        timer
    annotation (Placement(transformation(extent={{208,-58},{228,-38}})));
  Modelica.Blocks.Logical.Pre pre
    annotation (Placement(transformation(extent={{136,-58},{156,-38}})));
  Not not1
    annotation (Placement(transformation(extent={{-160,-100},{-140,-80}})));
  Equal                                                        equ1
    annotation (Placement(transformation(extent={{-240,-120},{-220,-100}})));
  Or or2 annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  And and2 annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
  Interfaces.BooleanOutput                                                y
    annotation (Placement(transformation(extent={{280,-10},{300,10}})));
  Interfaces.BooleanInput u
    annotation (Placement(transformation(extent={{-320,-20},{-280,20}})));
equation

  connect(timer.y,les1. u1) annotation (Line(points={{229,-48},{240,-48},{240,
          -66},{-182,-66},{-182,-30},{-180,-30},{-162,-30}},
                                                           color={0,0,127}));
  connect(timeOn.y,les1. u2) annotation (Line(points={{-259,80},{-260,80},{-256,
          80},{-210,80},{-210,-38},{-162,-38}}, color={0,0,127}));
  connect(timer.u,pre. y) annotation (Line(points={{206,-48},{194,-48},{157,-48}},
                      color={255,0,255}));
  connect(Zero.y,equ1. u1) annotation (Line(points={{-259,140},{-254,140},{-254,
          -110},{-242,-110}}, color={0,0,127}));
  connect(timer.y,equ1. u2) annotation (Line(points={{229,-48},{252,-48},{252,
          -140},{-254,-140},{-254,-138},{-254,-118},{-242,-118}}, color={0,0,
          127}));
  connect(equ1.y,not1. u) annotation (Line(points={{-219,-110},{-190,-110},{
          -190,-90},{-162,-90}}, color={255,0,255}));
  connect(u, or2.u1) annotation (Line(points={{-300,0},{-192,0},{-192,10},{-82,
          10}}, color={255,0,255}));
  connect(not1.y, or2.u2) annotation (Line(points={{-139,-90},{-108,-90},{-108,
          2},{-82,2}}, color={255,0,255}));
  connect(or2.y, and2.u1) annotation (Line(points={{-59,10},{-12,10},{-12,-30},
          {38,-30}}, color={255,0,255}));
  connect(les1.y, and2.u2) annotation (Line(points={{-139,-30},{-50,-30},{-50,
          -38},{38,-38}}, color={255,0,255}));
  connect(and2.y, pre.u) annotation (Line(points={{61,-30},{98,-30},{98,-48},{
          134,-48}}, color={255,0,255}));
  connect(or2.y, y) annotation (Line(points={{-59,10},{110,10},{110,0},{290,0}},
        color={255,0,255}));
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
