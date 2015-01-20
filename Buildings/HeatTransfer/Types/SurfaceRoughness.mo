within Buildings.HeatTransfer.Types;
type SurfaceRoughness = enumeration(
    VeryRough "Very rough",
    Rough "Rough",
    Medium "Medium rough",
    MediumSmooth "Medium smooth",
    Smooth "Smooth",
    VerySmooth "Very smooth") "Enumeration defining the surface roughness"
  annotation (Documentation(info="<html>
<p>
This enumeration is used to define the surface roughness
which may be used to compute the convective heat transfer coefficients of
building construction.
</p>
<p>
The surface roughness will be used to compute the
wind-driven convective heat transfer coefficient in
<a href=\"modelica://Buildings.HeatTransfer.Convection.Exterior\">
Buildings.HeatTransfer.Convection.Exterior</a>.
The possible surface roughness are
</p>
<table summary=\"summary\" border=\"1\">
<tr>
<th>Roughness index</th>
<th>Example material</th>
</tr>
<tr><td>VeryRough</td>     <td>Stucco</td></tr>
<tr><td>Rough</td>         <td>Brick</td></tr>
<tr><td>MediumRough</td>   <td>Concrete</td></tr>
<tr><td>MediumSmooth</td>  <td>Clear pine</td></tr>
<tr><td>Smooth</td>        <td>Smooth plaster</td></tr>
<tr><td>VerySmooth</td>    <td>Glass</td></tr>
</table>
</html>",
  revisions="<html>
<ul>
<li>
November 30 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
