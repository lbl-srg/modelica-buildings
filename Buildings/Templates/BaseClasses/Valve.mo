within Buildings.Templates.BaseClasses;
package Valve

  model EqualPercentage
    extends Interfaces.Valve(
      final typ=Buildings.Templates.Types.Valve.EqualPercentage);
    Fluid.Actuators.Valves.TwoWayEqualPercentage val
      annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  equation
    connect(port_a, val.port_a)
      annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
    connect(val.port_b, port_b)
      annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
    connect(busCon.out.y, val.y) annotation (Line(
        points={{0.1,100.1},{0.1,80},{-20,80},{-20,30},{0,30},{0,12}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-3,6},{-3,6}},
        horizontalAlignment=TextAlignment.Right));
    connect(val.y_actual, busCon.inp.y_actual) annotation (Line(points={{5,7},{
            20,7},{20,80},{0.1,80},{0.1,100.1}}, color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-3,6},{-3,6}},
        horizontalAlignment=TextAlignment.Right));
  end EqualPercentage;

  model Linear
    extends Interfaces.Valve(
      final typ=Buildings.Templates.Types.Valve.EqualPercentage);
    Fluid.Actuators.Valves.TwoWayLinear val
      annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  equation
    connect(port_a, val.port_a)
      annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
    connect(val.port_b, port_b)
      annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
    connect(busCon.out.y, val.y) annotation (Line(
        points={{0.1,100.1},{0.1,80},{-20,80},{-20,30},{0,30},{0,12}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-3,6},{-3,6}},
        horizontalAlignment=TextAlignment.Right));
    connect(val.y_actual, busCon.inp.y_actual) annotation (Line(points={{5,7},{
            20,7},{20,80},{0.1,80},{0.1,100.1}}, color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-3,6},{-3,6}},
        horizontalAlignment=TextAlignment.Right));
  end Linear;

  model None
    extends Interfaces.Valve(
      final typ=Buildings.Templates.Types.Valve.None);
    PassThroughFluid pas
      annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  equation
    connect(port_a, pas.port_a)
      annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
    connect(pas.port_b, port_b)
      annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={Line(
            points={{-100,0},{100,0}},
            color={28,108,200},
            thickness=1)}),                                        Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end None;
end Valve;
