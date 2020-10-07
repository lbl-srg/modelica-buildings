within Buildings.Experimental.NaturalVentilation;
package Validation "Validation model for Nat Vent control"






annotation (Documentation(info="<html>
  <p>
  This package contains validation models for each of the natural ventilation modules. 
  The three main modules are as follows, and are listed with their respective natural ventilation modules. 
  <p>
  1. Natural Ventilation Module
  <li>a. Natural ventilation control modeled with dummy inputs
  <p>
  2. Natural Ventilation Module with a Dynamic Duration Night Flush
  <li>a. NaturalVentilationNightFlushDynamicExteriorSF: Natural ventilation & night flush control modeled for a perimeter zone
  <li>(i.e., a room with walls exposed to the outdoors) with San Francisco weather data
  <li>b. NaturalVentilationNightFlushDynamicInterior: Natural ventilation control modeled for a core zone 
  <li>(i.e., a room with no walls exposed to the outdoors) 
  <p>
  3. Natural Ventilation Module with a Fixed Duration Night Flush
  <li>a. NaturalVentilationNightFlushDynamicExteriorChicago: Natural ventilation & night flush control modeled for a perimeter zone 
  <li>(i.e., a room with walls exposed to the outdoors) with Chicago weather data
  <li>b. NaturalVentilationNightFlushDynamicExteriorSF: Natural ventilation control modeled for a perimeter zone
  <li>(i.e., a room with walls exposed to the outdoors) with San Francisco weather data
  <li>c. NaturalVentilationNightFlushFixedInterior: Natural ventilation control modeled for a core zone 
  <li>(i.e., a room with no walls exposed to the outdoors)  
  <p>

<p>
</p>
</p>
</html>", revisions="<html>
<ul>
<li>
October 6, 2020, by Fiona Woods:<br/>
Updated package description.<br/>
</li>
</html>"));
end Validation;
