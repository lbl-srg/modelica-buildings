within Buildings.Fluid;
package Interfaces "Package with interfaces for fluid models"
  extends Modelica.Icons.InterfacesPackage;
annotation (preferedView="info", Documentation(info="<html>
This package contains basic classes that are used to build
component models that change the state of the
fluid. The classes are not directly usable, but can
be extended when building a new model.
</html>"));

package UsersGuide "User's Guide"
  extends Modelica.Icons.Information;
  annotation (DocumentationClass=true, Documentation(info="<html>
<p>
The package <code>Buildings.Fluid.Interface</code> consists of basic
classes that can be used by developers to create new component models.
</p>
<p>
The classes whose name contains <code>TwoPort</code> or 
<code>FourPort</code> can be used for components with 
two or four fluid ports, respectively. If a class name contains
<code>Static</code>, then it can only be used for a steady-state model.
Otherwise, it may be used for a steady-state or a dynamic model.
</p>
<p>
The most basic classes are the records
<a href=\"modelica://Buildings.Fluid.Interfaces.TwoPortFlowResistanceParameters\">
Buildings.Fluid.Interfaces.TwoPortFlowResistanceParameters</a>,
<a href=\"modelica://Buildings.Fluid.Interfaces.FourPortFlowResistanceParameters\">
Buildings.Fluid.Interfaces.FourPortFlowResistanceParameters</a> and
<a href=\"modelica://Buildings.Fluid.Interfaces.LumpedVolumeDeclarations\">
Buildings.Fluid.Interfaces.LumpedVolumeDeclarations</a>.
These define parameters that are needed by many fluid flow components.
</p>
<p>
Next, we describe the basic classes. For a more detailed description,
see the <i>info</i> section of the class.
</p>
<p>
<table>
<tr>
<!-- -------------------------------- -->
  <td><a href=\"modelica://Buildings.Fluid.Interfaces.LumpedVolume\">
      Buildings.Fluid.Interfaces.LumpedVolume</a>
  </td>
  <td>This is a basic model for an ideally mixed fluid volume 
      with the ability to store mass and energy.
      Models that instanciate this model need to define the inputs
<ul>
<li>
<code>fluidVolume</code>, which is the actual volume occupied by the fluid.
For most components, this can be set to a parameter. However, for components such as 
expansion vessels, the fluid volume can change in time.
</li>
<li>
<code>Q_flow</code>, which is the sensible plus latent heat flow rate added to the medium.
</li>
<li>
<code>mXi_flow</code>, which is the species mass flow rate added to the medium.
</li>
</ul>
  </td>
</tr>
<!-- -------------------------------- -->
<tr>
  <td>
     <a href=\"modelica://Buildings.Fluid.Interfaces.FourPort\">
                          Buildings.Fluid.Interfaces.FourPort</a>
  </td>
  <td>
     This model defines an interface for components with four ports. 
     Only parameters and fluid definitions are provided, but no
     equations.
     The model is identical to 
     <a href=\"modelica://Modelica.Fluid.Interfaces.PartialTwoPort\">
     Modelica.Fluid.Interfaces.PartialTwoPort</a>, except that it has 
     four ports.
  </td>
</tr>
<!-- -------------------------------- -->
<tr>
  <td>
     <a href=\"modelica://Buildings.Fluid.Interfaces.PartialTwoPortInterface\">
                          Buildings.Fluid.Interfaces.PartialTwoPortInterface</a>
  </td>
  <td>
     This model defines the interface for component models that transport
     fluid, and that can exchange heat and mass.
     It also defines the port pressure difference as 
     <i>&Delta;p = p<sub>a</sub>-p<sub>b</sub></i>. However, no equation is
     implemented to compute <i>&Delta;p(&sdot;)</i> as a function of the
     mass flow rate. The model also implements equations to obtain the
     thermodynamic state at the ports.
  </td>
</tr>
<!-- -------------------------------- -->
<tr>
  <td>
     <a href=\"modelica://Buildings.Fluid.Interfaces.PartialFourPortInterface\">
                          Buildings.Fluid.Interfaces.PartialFourPortInterface</a>
  </td>
  <td>
     This model is identical to 
     <a href=\"modelica://Buildings.Fluid.Interfaces.PartialTwoPortInterface\">
                          Buildings.Fluid.Interfaces.PartialTwoPortInterface</a>
     but it can be used for components with four fluid ports.
  </td>
</tr>
<!-- -------------------------------- -->
<tr>
  <td>
     <a href=\"modelica://Buildings.Fluid.Interfaces.StaticTwoPortHeatMassExchanger\">
                          Buildings.Fluid.Interfaces.StaticTwoPortHeatMassExchanger</a>
  </td>
  <td>
     This model implements the pressure drop as a function of the mass flow rate. 
     It also implements the steady-state energy and mass conservation 
     equations. However, it does not implement an equation that computes 
     <code>Q_flow</code>, the 
     sensible and latent heat transfer to the medium flow, nor
     does it implement an equation for <code>mXi_flow</code>, 
     the species mass flow rate added to or removed from the medium. 
     Models that extend this model need to provide equations
     for <code>Q_flow</code> and <code>mXi_flow</code>.
  </td>
</tr>
<!-- -------------------------------- -->
<tr>
  <td>
     <a href=\"modelica://Buildings.Fluid.Interfaces.StaticFourPortHeatMassExchanger\">
                          Buildings.Fluid.Interfaces.StaticFourPortHeatMassExchanger</a>
  </td>
  <td>
     This model is identical to 
     <a href=\"modelica://Buildings.Fluid.Interfaces.StaticTwoPortHeatMassExchanger\">
                          Buildings.Fluid.Interfaces.StaticTwoPortHeatMassExchanger</a>
     except that it has four ports.
  </td>
</tr>
<!-- -------------------------------- -->
<tr>
  <td>
     <a href=\"modelica://Buildings.Fluid.Interfaces.TwoPortHeatMassExchanger\">
                          Buildings.Fluid.Interfaces.TwoPortHeatMassExchanger</a>
  </td>
  <td>
     This model implements the pressure drop as a function of the mass flow rate. 
     It also implements the energy and mass conservation equations, which may be
     configured as steady-state or dynamic balances based on a parameter. 
  </td>
</tr>
<!-- -------------------------------- -->
<tr>
  <td>
     <a href=\"modelica://Buildings.Fluid.Interfaces.FourPortHeatMassExchanger\">
                          Buildings.Fluid.Interfaces.FourPortHeatMassExchanger</a>
  </td>
  <td>
     This model is identical to 
     <a href=\"modelica://Buildings.Fluid.Interfaces.TwoPortHeatMassExchanger\">
                          Buildings.Fluid.Interfaces.TwoPortHeatMassExchanger</a>
     except that it has four ports.
  </td>
</tr>
</table>
</p>
</html>"));

end UsersGuide;

end Interfaces;
