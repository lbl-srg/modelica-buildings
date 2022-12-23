within Buildings.Experimental.DHC.Plants.Combined.Subsystems;
model ChillerGroup "Group of multiple identical chillers in parallel"
  extends BaseClasses.PartialChillerGroup;

equation
  connect(mulConInl.port_b, chi.port_a1) annotation (Line(points={{-30,60},{-20,
          60},{-20,-48},{-10,-48}}, color={0,127,255}));
  connect(chi.port_b1, mulConOut.port_a) annotation (Line(points={{10,-48},{20,
          -48},{20,60},{30,60}}, color={0,127,255}));
  connect(mulP.y, P) annotation (Line(points={{52,-100},{60,-100},{60,120},{120,
          120}}, color={0,0,127}));
  connect(com.nUniOnBou, mulConOut.u) annotation (Line(points={{-68,126},{20,
          126},{20,66},{28,66}}, color={0,0,127}));
  annotation (defaultComponentName="chi");
end ChillerGroup;
