within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.AtomicSequences;
model ModesTempDocumentation
  "We use integer enumerations for modes. The Info of this model is used as a legend."

  annotation (
    defaultComponentName = "ModesLegend",
    Documentation(info="<html>      
<p>
This block provides the mapping between integers used in the G36 atomic and composite
library and the related Modes, as listed in PART5.B (Generic Thermal Zones) and 
PART5.M (Air Handling Unit System Modes).
</p>   
<p>
PART5.B.6 - Zone State<br/>
1 - Heating<br/>
2 - Deadband<br/>
3 - Cooling<br/>
<br/>

PART5.M.1 - AHU System Mode<br/>
1 - Occupied Mode<br/>
2 - Cool-down Mode<br/>
3 - Setup Mode<br/>
4 - Warmup Mode<br/>
5 - Setback Mode<br/>
6 - Freeze Protection Setback Mode<br/>
7 - Unoccupied Mode<br/>


</p>

</html>", revisions="<html>
<ul>
<li>
June 02, 2017, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end ModesTempDocumentation;
