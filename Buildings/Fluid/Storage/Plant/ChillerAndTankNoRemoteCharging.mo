within Buildings.Fluid.Storage.Plant;
model ChillerAndTankNoRemoteCharging
  "(Draft) Model of a plant with a chiller and a tank where the tank cannot be charged remotely"
  extends Buildings.Fluid.Storage.Plant.BaseClasses.ChillerAndTank;

  Modelica.Blocks.Interfaces.RealInput yPum2 "Secondary pump speed input"
    annotation (Placement(transformation(extent={{-204,58},{-180,82}}),
        iconTransformation(extent={{-120,40},{-100,60}})));
equation
  connect(pum2.y, yPum2)
    annotation (Line(points={{-150,32},{-150,70},{-192,70}}, color={0,0,127}));
  connect(pum2.port_a, port_a) annotation (Line(points={{-160,20},{-166,20},{
          -166,0},{-180,0}}, color={0,127,255}));
  connect(pum2.port_b, jun1.port_1) annotation (Line(points={{-140,20},{-96,20},
          {-96,0},{-90,0}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}})),                                        Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-180,-100},{100,100}})));
end ChillerAndTankNoRemoteCharging;
