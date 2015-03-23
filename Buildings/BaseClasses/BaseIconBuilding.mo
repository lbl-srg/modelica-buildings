within Buildings.BaseClasses;
block BaseIconBuilding "Base icon for a commercial building model"
  extends BaseIcon;
  annotation (Icon(graphics={
        Polygon(
          points={{-100,60},{-20,100},{100,40},{20,0},{-20,20},{20,40},{-20,60},
              {-60,40},{-100,60}},
          lineColor={0,0,0},
          fillColor={211,84,0},
          fillPattern=FillPattern.Solid,
          smooth=Smooth.None),
        Polygon(
          points={{-20,20},{-20,-80},{20,-100},{20,0},{-20,20}},
          lineColor={0,0,0},
          fillColor={248,148,6},
          fillPattern=FillPattern.Solid,
          smooth=Smooth.None),
        Polygon(
          points={{-100,60},{-100,-40},{-60,-60},{-60,40},{-100,60}},
          lineColor={0,0,0},
          fillColor={248,148,6},
          fillPattern=FillPattern.Solid,
          smooth=Smooth.None),
        Polygon(
          points={{20,0},{20,-100},{100,-60},{100,40},{20,0}},
          lineColor={0,0,0},
          fillColor={248,148,60},
          fillPattern=FillPattern.Solid,
          smooth=Smooth.None),
        Polygon(
          points={{-60,40},{-60,-60},{-20,-40},{-20,60},{-60,40}},
          lineColor={0,0,0},
          fillColor={248,148,60},
          fillPattern=FillPattern.Solid,
          smooth=Smooth.None),
        Polygon(
          points={{-20,60},{-20,20},{20,40},{-20,60}},
          lineColor={0,0,0},
          fillColor={242,121,53},
          fillPattern=FillPattern.Solid,
          smooth=Smooth.None),
        Polygon(
          points={{-98,50},{-98,44},{-62,26},{-62,32},{-98,50}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={129,207,224},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-98,32},{-98,26},{-62,8},{-62,14},{-98,32}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={129,207,224},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-98,14},{-98,8},{-62,-10},{-62,-4},{-98,14}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={129,207,224},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-98,-4},{-98,-10},{-62,-28},{-62,-22},{-98,-4}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={129,207,224},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-98,-22},{-98,-28},{-62,-46},{-62,-40},{-98,-22}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={129,207,224},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-18,10},{-18,4},{18,-14},{18,-8},{-18,10}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={129,207,224},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-18,-8},{-18,-14},{18,-32},{18,-26},{-18,-8}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={129,207,224},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-18,-26},{-18,-32},{18,-50},{18,-44},{-18,-26}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={129,207,224},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-18,-44},{-18,-50},{18,-68},{18,-62},{-18,-44}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={129,207,224},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-18,-62},{-18,-68},{18,-86},{18,-80},{-18,-62}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={129,207,224},
          fillPattern=FillPattern.Solid)}), Documentation(revisions="<html>
<ul>
<li>
March 23, 2015, by Marco Bonvini:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
Basic class that provides a label with the component name above the icon
of a commercial building.
</p>
</html>"));
end BaseIconBuilding;
