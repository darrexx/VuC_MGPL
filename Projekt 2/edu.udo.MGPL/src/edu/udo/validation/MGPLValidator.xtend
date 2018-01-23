/*
 * generated by Xtext 2.12.0
 */
package edu.udo.validation

import edu.udo.mGPL.Expression
import edu.udo.mGPL.IntLiteral
import edu.udo.mGPL.impl.ExpressionImpl
import org.eclipse.xtext.validation.Check
import edu.udo.mGPL.Prog
import edu.udo.mGPL.Programm

/**
 * This class contains custom validation rules. 
 *
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#validation
 */
class MGPLValidator extends AbstractMGPLValidator {
	
//	public static val INVALID_NAME = 'invalidName'
//
//	@Check
//	def checkGreetingStartsWithCapital(Greeting greeting) {
//		if (!Character.isUpperCase(greeting.name.charAt(0))) {
//			warning('Name should start with a capital', 
//					MGPLPackage.Literals.GREETING__NAME,
//					INVALID_NAME)
//		}
//	}

	@Check
	def expressionTypeCheck(Expression expression){
		switch expression.op{
			case 'touches': 
				{} // Check if Left & Right are of type ObjectDecl
			case null: // No op defined
				{}  
			default: // Default Arithmetic operation 
				{} //Check if left & right are numbers
		}
	}
	
	@Check
	def checkProgramSpeed(Programm prog){
		
	}
}
