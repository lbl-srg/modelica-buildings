within Buildings.Utilities.IO.Strings;
connector StringInput = input String "'input String' as connector"
annotation (Documentation(info="<html>
<p>
  Input connector for a String. 
</p>
</html>", revisions="<html><ul>
  <li>
    <i>October 2, 2022</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">#1576</a>)
  </li>
</ul>
</html>"), Icon(graphics={
    Polygon(
      lineColor={0,100,0},
      fillColor={0,100,0},
      fillPattern=FillPattern.Solid,
      points={{-100,100},{100,0},{-100,-100}})}));
