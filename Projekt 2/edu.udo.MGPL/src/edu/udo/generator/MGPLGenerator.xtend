/*
 * generated by Xtext 2.12.0
 */
package edu.udo.generator

import edu.udo.mGPL.Add
import edu.udo.mGPL.And
import edu.udo.mGPL.Animation
import edu.udo.mGPL.AnimationParameter
import edu.udo.mGPL.ArrayElementSelect
import edu.udo.mGPL.AssignmentStatement
import edu.udo.mGPL.AttributeAssignment
import edu.udo.mGPL.AttributeAssignments
import edu.udo.mGPL.Declaration
import edu.udo.mGPL.Event
import edu.udo.mGPL.Expression
import edu.udo.mGPL.ForStatement
import edu.udo.mGPL.IfStatement
import edu.udo.mGPL.IntArrayDecl
import edu.udo.mGPL.IntDecl
import edu.udo.mGPL.IntLiteral
import edu.udo.mGPL.MemberSelect
import edu.udo.mGPL.Mult
import edu.udo.mGPL.Negation
import edu.udo.mGPL.ObjArrayDecl
import edu.udo.mGPL.ObjDecl
import edu.udo.mGPL.Or
import edu.udo.mGPL.Programm
import edu.udo.mGPL.Rel
import edu.udo.mGPL.Statements
import edu.udo.mGPL.Touches
import edu.udo.mGPL.Var
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.AbstractGenerator
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.IGeneratorContext
import java.util.ArrayList
import java.util.List

/**
 * Generates code from your model files on save.
 * 
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#code-generation
 */
class MGPLGenerator extends AbstractGenerator {

	List<String> initstmts;

	override void doGenerate(Resource resource, IFileSystemAccess2 fsa, IGeneratorContext context) {
		initstmts = new ArrayList<String>();
		//fsa.generateFile('mgpl_generated.java',compile(resource.allContents.toIterable.findFirst[typeof(Programm)])
		for(e: resource.allContents.toIterable.filter(typeof(Programm)))
		{
			fsa.generateFile(e.name + ".java", e.compile())
		}
	}
	
	def compile(Programm prog) '''
	import java.util.*;
	//JavaFX
	import javafx.scene.input.KeyEvent;
	import javafx.animation.KeyFrame;
	import javafx.scene.input.KeyCode;
	import javafx.event.EventHandler;
	import javafx.animation.Timeline;
	import javafx.application.Application;
	import javafx.scene.Scene;
	import javafx.scene.canvas.Canvas;
	import javafx.scene.canvas.GraphicsContext;
	import javafx.scene.layout.StackPane;
	import javafx.scene.paint.Color;
	import javafx.stage.Stage;
	import javafx.scene.shape.Circle;
	import javafx.scene.shape.Rectangle;
	import javafx.scene.shape.Polygon;
	import javafx.scene.shape.Shape;
	import javafx.util.Duration;
	//End JavaFX
	
	// Generiert durch 
	// Nils Bergmann 165409
	// Hendrik Schr�der 165789
	// Timo Walter 166042
	
	public class �prog.name.toFirstUpper� extends Application{
		public static void main(String[] args) {
		        launch(args);
		}
		public abstract class Animation {
			public abstract void animate(AnimatableObject anim);
		}
				
		public abstract class AnimatableObject {
			public int x;
			public int y;
			public boolean visible = true;
			public Animation animation_block;
			public int height;
			public int width;
			public int radius;
			public abstract Shape toShape();
		}
		public class Circle extends AnimatableObject{
			public Shape toShape(){
				javafx.scene.shape.Circle retVal = new javafx.scene.shape.Circle(this.x, this.y, this.radius);
				return retVal;
			}
		}
		public class Rectangle extends AnimatableObject{
			public Shape toShape(){
				javafx.scene.shape.Rectangle retVal = new javafx.scene.shape.Rectangle(this.x, this.y, this.width, this.height);
				return retVal; 
			}
		}
		public class Triangle extends AnimatableObject{
			public Shape toShape(){
				Polygon polygon = new Polygon();
				polygon.getPoints().addAll(new Double[]{
					(double)x, (double)y,
					(double)x+width, (double)y,
					(double)x+(width/2), (double)y+height });
				return polygon;
			}
		}
		//List of animatable Objects
		List<Circle> circles = new ArrayList<Circle>();
		List<Rectangle> rectangles = new ArrayList<Rectangle>();
		List<Triangle> triangles = new ArrayList<Triangle>();	
		
		//Declarations
		�FOR ass:(prog.attrAssList as AttributeAssignments).assignments�
		public int �(ass as AttributeAssignment).name� = �(ass as AttributeAssignment).expr.compile�;
		�ENDFOR�
		�FOR d:prog.decl�
		�d.compile�
		�ENDFOR�
		//Declarations end
		//Statements
		public void init(){
			�initstmts.read�
			�(prog.stmtBlock as Statements).compile�
		}
		//Statements end
		
		//Animations 
		�FOR d:prog.block.filter[x | x instanceof Animation]�
			�compile(d as Animation)�
		�ENDFOR�		
		//Animations end
		
			
		//JavaFX
		public void start(Stage stage){
			Canvas canvas = new Canvas(width, height);
			canvas.setFocusTraversable(true);
			GraphicsContext gc = canvas.getGraphicsContext2D();
			Timeline tl = new Timeline(new KeyFrame(Duration.millis(102-speed), e -> run(gc)));
			tl.setCycleCount(Timeline.INDEFINITE);
			canvas.setOnKeyPressed(new EventHandler<KeyEvent>() {
				@Override
				public void handle(KeyEvent event) {
					�FOR d:prog.block.filter[x | x instanceof Event]�
						�compile(d as Event)�
					�ENDFOR�
				}
			});
			canvas.setFocusTraversable(true);
			stage.setScene(new Scene(new StackPane(canvas)));
			stage.show();
			tl.play();
		}
		
		private void run(GraphicsContext gc){
			gc.clearRect(0, 0, width, height);
			for(Circle circle : circles){
				if(circle.animation_block != null){
					circle.animation_block.animate(circle);
				}
				if(circle.visible){
					gc.fillOval(circle.x, circle.y, circle.radius*2, circle.radius*2);
				}
			}
			for(Rectangle rectangle : rectangles){
				if(rectangle.animation_block != null){
					rectangle.animation_block.animate(rectangle);
				}
				if(rectangle.visible){
					gc.fillRect(rectangle.x, rectangle.y, rectangle.width, rectangle.height);
				}
			}
			for(Triangle triangle : triangles){
				if(triangle.animation_block != null){
					triangle.animation_block.animate(triangle);
				}
				double[] pointsY = new double[]{
						(double)triangle.y,
						(double)triangle.y,
						(double)triangle.y+triangle.height };
				double[] pointsX = new double[]{
						(double)triangle.x,
						(double)triangle.x+triangle.width,
						(double)triangle.x+(triangle.width/2)};
				if(triangle.visible){
					gc.fillPolygon(pointsX, pointsY, pointsX.length);
				}
			}
		}
		//End JavaFX
		
		//touches
			public static boolean touches(AnimatableObject a, AnimatableObject b){
				//TODO: Test JavaFX.Shapes.intersect
				Shape intersection = Shape.intersect(a.toShape(), b.toShape());
				if (intersection.getBoundsInLocal().getWidth() != -1) 
				     return true; 
				return false;
			}
		//end touches
	}
	'''
	
	def String read(List<String> strings){
		val builder = new StringBuilder();
		for(String string : strings){
			builder.append(string);
			builder.append(System.getProperty("line.separator"));
		}
		return builder.toString();
	}
	
	def compile(Declaration decl) '''
	�IF decl instanceof IntDecl�
	�compile(decl as IntDecl)�
	�ENDIF�
	�IF decl instanceof IntArrayDecl�
	�compile(decl as IntArrayDecl)�
	�ENDIF�
	�IF decl instanceof ObjDecl�
	�compile(decl as ObjDecl)�
	�ENDIF�
	�IF decl instanceof ObjArrayDecl�
	�compile(decl as ObjArrayDecl)�
	�ENDIF�
	'''
	
	def compile(IntDecl decl) '''
	public int �decl.name��IF decl.init !== null� = �decl.init.expr.compile��ENDIF�;
	'''
	
	def compile(IntArrayDecl decl) '''
	public �decl.type�[] �decl.name� = new �decl.type�[�decl.size�];
	'''
	
	def compile(ObjArrayDecl decl){
		initstmts.add('''for(int j=0; j<�decl.size�; j++){
	�decl.name�[j] = new �decl.type.toFirstUpper�();
}''')
		initstmts.add('''Collections.addAll(�decl.type.toLowerCase�s, �decl.name�);''');
		return '''
			public �decl.type.toFirstUpper�[] �decl.name� = new �decl.type.toFirstUpper�[�decl.size�];
			'''
	} 
	
	def compile(ObjDecl decl){
		if(decl.attrAssList !== null){
			(decl.attrAssList as AttributeAssignments).compile(decl.name)
			initstmts.add('''�decl.type.toLowerCase�s.add(�decl.name�);''')
		}
		return '''
			public �decl.type.toFirstUpper� �decl.name� = new �decl.type.toFirstUpper�();
			�IF decl.attrAssList !== null��(decl.attrAssList as AttributeAssignments).compile(decl.name)��ENDIF�

			'''
	} 
	
	def compile(AttributeAssignments list, String objName){
		for(a : list.assignments){
			(a as AttributeAssignment).compile(objName)
		}
	}
	def compile(AttributeAssignment ass, String objName){
		var fixedMemberName = ""
		switch ass.name{
			case "w": fixedMemberName = "width"
			case "h": fixedMemberName = "height"
			case "r": fixedMemberName = "radius"
			default: fixedMemberName = ass.name
		}
		initstmts.add('''�objName�.�fixedMemberName� = �ass.expr.compile�;''');
	}
	
	
	def compile(Statements stmts)'''
	�FOR stmt:stmts.stmt�
	�IF stmt instanceof IfStatement�
	�compile(stmt as IfStatement)�
	�ENDIF�
	�IF stmt instanceof ForStatement�
	�compile(stmt as ForStatement)�
	�ENDIF�
	�IF stmt instanceof AssignmentStatement�
	�compile(stmt as AssignmentStatement)�
	�ENDIF�
	�ENDFOR�'''
	
	def compile(IfStatement stmt)'''
	if(�(stmt.condition as Expression).compile�){
		�(stmt.stmtBlockIf as Statements).compile�
	}�IF stmt.stmtBlockElse !== null� else {
		�(stmt.stmtBlockElse as Statements).compile�
	}�ENDIF�'''
	
	def compile(AssignmentStatement stmt)'''
	�stmt.^var.compile� = �IF (stmt.^var instanceof MemberSelect) && (stmt.^var as MemberSelect).memberName == "visible"��IF (stmt.expr as IntLiteral).value == 0�false�ENDIF��IF (stmt.expr as IntLiteral).value == 1�true�ENDIF��ELSE��stmt.expr.compile��ENDIF�;'''
	
	def compile(ForStatement stmt)'''
	�(stmt.loopInit as AssignmentStatement).compile� //loopInit
	while(�(stmt.loopCondition as Expression).compile�){ //loopCondition
		�(stmt.stmtBlock as Statements).compile�
		�(stmt.loopIncrement as AssignmentStatement).compile� //loopIncrement
	}'''
	
	def compile(Animation anim)'''
	private class �anim.name.toFirstUpper� extends Animation {
		public void animate(AnimatableObject �(anim.param as AnimationParameter).name�){
			�(anim.stmtBlock as Statements).compile�
		}
	}
	'''
	
	def compile(Expression e){
		switch e{ 
			Or:  '''�e.left.compile��IF e.right !== null� �e.op� �e.right.compile��ENDIF�'''
			And : '''�e.left.compile��IF e.right !== null� �e.op� �e.right.compile��ENDIF�'''
			Rel : '''�e.left.compile��IF e.right !== null� �e.op� �e.right.compile��ENDIF�'''
			Add : '''�e.left.compile��IF e.right !== null� �e.op� �e.right.compile��ENDIF�'''
			Mult : '''�e.left.compile��IF e.right !== null� �e.op� �e.right.compile��ENDIF�'''
			Negation : '''�e.op��e.exprAtom.compile�'''
			IntLiteral : '''�e.value�'''
			Touches : '''touches(�e.left.compile�, �e.right.compile�) '''
			default: '''�IF e.expr !== null�(�e.expr�) �ELSE��e.^var.compile��ENDIF�'''	
		}
	}
	
	def compile(Event event)'''
	   		if( �IF event.keystroke == "rightarrow"�
	   			event.getCode() == KeyCode.RIGHT ) {
	   		�ELSEIF event.keystroke == "leftarrow"�
	   			event.getCode() == KeyCode.LEFT ) {
	   		�ELSEIF event.keystroke == "uparrow"�
	   			event.getCode() == KeyCode.UP ) {
	   		�ELSEIF event.keystroke == "downarrow"�
	   			event.getCode() == KeyCode.DOWN ) {
	   		�ELSE /*Space*/�
	   			event.getCode() == KeyCode.SPACE ) {
	   		�ENDIF�
	   			�(event.stmtBlock as Statements).compile�
	   		}
	'''
	
//	on rightarrow
//{
//    if (gun.x < Invaders.width - 50)
//       { gun.x = gun.x + 5; } 
//}
//
//
//// input handler for space which fires the gun
//
//on space
//{
//    // find a bullet that isn't currently active
//    for (i = 0; i < 5; i = i+1)
//    {
//        if (! bullets[i].visible)
//        { bullets[i].visible = 1;
//	    bullets[i].x = gun.x + gun.w/2;
//	    bullets[i].y = gun.y + gun.h;
//	    i = 6; // break out of the loop
//        } 
//    }
//}
//	
	
	def compile(Var ^var){ //Todo funktioniert irgendwie nicht
		if(^var instanceof ArrayElementSelect){
			return '''�compile(^var as ArrayElementSelect)�'''
		} else if(^var instanceof MemberSelect){
			return '''�compile(^var as MemberSelect)�'''
		} else {
			var varName = ^var.name
			switch varName{
				Programm:'''�varName.name�'''
				IntDecl:'''�varName.name�'''
				ObjDecl:'''�varName.name�'''
				ObjArrayDecl:'''�varName.name�'''
				AnimationParameter:'''�varName.name�'''
				Animation:'''new �varName.name.toFirstUpper�()'''
				default:'''�varName.eClass�'''
			}
		}
	}
	
	def compile(ArrayElementSelect arr){
		'''�compile(arr.variable)�[�compile(arr.index)�]'''
	}
	
	def compile(MemberSelect mem){
		var fixedMemberName = ""
		switch mem.memberName{
			case "w": fixedMemberName = "width"
			case "h": fixedMemberName = "height"
			case "r": fixedMemberName = "radius"
			default: fixedMemberName = mem.memberName
		}
	'''�IF mem.variable.name instanceof Programm��ELSE��compile(mem.variable)�.�ENDIF��fixedMemberName�'''
	}
	
	def createDataClasses(){
		'''
		public class GeometricObject {
			int x;
			int y;
			boolean visible;
			
		}
		'''
	}
}
