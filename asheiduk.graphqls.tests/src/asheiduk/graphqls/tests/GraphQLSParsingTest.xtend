package asheiduk.graphqls.tests

import asheiduk.graphqls.graphQLS.Document
import com.google.inject.Inject
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.extensions.InjectionExtension
import org.eclipse.xtext.testing.util.ParseHelper
import org.junit.jupiter.api.Assertions
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.^extension.ExtendWith

@ExtendWith(InjectionExtension)
@InjectWith(GraphQLSInjectorProvider)
class GraphQLSParsingTest {
	
	@Inject extension ParseHelper<Document> parseHelper
	
	def private void shallParse(CharSequence it){
		val result = parse
		Assertions.assertNotNull(result)
		val errors = result.eResource.errors
		Assertions.assertTrue(errors.isEmpty, '''Unexpected errors: «errors.join(", ")»''')
	}
	
	@Test
	def void xidWorkshopExample() {
		'''
			type Task
			input AddTaskInput
			
			type Mutation {
				addTask(projectId: ID, input: AddTaskInput!): Task!
			}
		'''.shallParse
	}
	
	@Test
	def void xidType() {
		'''
			type type @type(type: "type") {
				type(type: type): type
			}
		'''.shallParse
	}
	
	@Test
	def void xidInput() {
		'''
			input input {
				input: input
			}
		'''.shallParse
	}
	
	@Test
	def void intValue() {
		'''
			type MyType{
				MyField (
					intArg1 : Int =   0
					intArg2 : Int =  -0
					
					intArg3 : Int =   1
					intArg4 : Int =  -1
					
					intArg5 : Int =  42
					intArg6 : Int = -42
				): ID 
			}
		'''.shallParse
	}
	
	@Test
	def void floatValue() {
		'''
			type MyType{
				MyField (
					floatArg1 : Float =  42.42
					floatArg2 : Float = -42.42
					
					floatArg3 : Float =  42e42
					floatArg4 : Float =  42e+42
					floatArg5 : Float =  42e-42
					floatArg6 : Float = -42e-42
					
					floatArg7 : Float =  42.42e42
					floatArg8 : Float =  42.42e+42
					floatArg9 : Float =  42.42e-42
					floatArg10: Float = -42.42e-42
				): ID
			}
		'''.shallParse
	}
}
