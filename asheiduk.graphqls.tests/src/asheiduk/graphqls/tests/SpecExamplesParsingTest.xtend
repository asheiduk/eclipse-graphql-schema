package asheiduk.graphqls.tests

import asheiduk.graphqls.graphQLS.Document
import com.google.inject.Inject
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.extensions.InjectionExtension
import org.eclipse.xtext.testing.util.ParseHelper
import org.junit.jupiter.api.Assertions
import org.junit.jupiter.api.Disabled
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.^extension.ExtendWith

/**
 * Testcases of the section "Type System" in the spec
 * 
 * https://graphql.github.io/graphql-spec/June2018/#sec-Type-System
 * 
 */
@ExtendWith(InjectionExtension)
@InjectWith(GraphQLSInjectorProvider)
class SpecExamplesParsingTest {
	
	@Inject extension ParseHelper<Document> parseHelper
	
	def private void shallParse(CharSequence it){
		val result = parse
		Assertions.assertNotNull(result)
		val errors = result.eResource.errors
		Assertions.assertTrue(errors.isEmpty, '''Unexpected errors: «errors.join(", ")»''')
	}
	
	@Test
	def void exampleNo35(){
		'''
			type Query {
			  myName: String
			}
		'''.shallParse
	}
	
	@Test
	def void exampleNo37(){
		'''
			schema {
			  query: MyQueryRootType
			  mutation: MyMutationRootType
			}
			
			type MyQueryRootType {
			  someField: String
			}
			
			type MyMutationRootType {
			  setSomeField(to: String): String
			}
		'''.shallParse
	}
	
	@Test
	def void exampleNo38(){
		'''
			type Query {
			  someField: String
			}
		'''.shallParse
	}
	
	@Test
	def void exampleNo39(){
		'''
			"""
			A simple GraphQL schema which is well described.
			"""
			type Query {
			  """
			  Translates a string from a given language into a different language.
			  """
			  translate(
			    "The original language that `text` is provided in."
			    fromLanguage: Language
			
			    "The translated language to be returned."
			    toLanguage: Language
			
			    "The text to be translated."
			    text: String
			  ): String
			}
			
			"""
			The set of languages supported by `translate`.
			"""
			enum Language {
			  "English"
			  EN
			
			  "French"
			  FR
			
			  "Chinese"
			  CH
			}
		'''.shallParse
	}
	
	@Test
	def void exampleNo40(){
		'''
			scalar Time
			scalar Url
		'''.shallParse
	}
	
	@Test
	def void exampleNo41(){
		'''
			type Person {
			  name: String
			  age: Int
			  picture: Url
			}
		'''.shallParse
	}
	
	@Test
	def void exampleNo46(){
		'''
			type Person {
			  name: String
			  age: Int
			  picture: Url
			  relationship: Person
			}
		'''.shallParse
	}
	
	@Test
	def void exampleNo56(){
		'''
			type Person {
			  name: String
			  picture(size: Int): Url
			}
		'''.shallParse
	}
	
	@Test
	def void exampleNo59(){
		'''
			type ExampleType {
			  oldField: String @deprecated
			}
		'''.shallParse
	}
		
//	@Test
//	def void exampleNo60(){
//		'''
//			extend type Story {
//			  isHiddenLocally: Boolean
//			}
//		'''.doParse
//	}
	
	
//	@Test
//	def void exampleNo61(){
//		'''
//			extend type User @addedDirective
//		'''.doParse
//	}
	
	@Test
	def void exampleNo62_63(){
		'''
			interface NamedEntity {
			  name: String
			}
			
			interface ValuedEntity {
			  value: Int
			}
			
			type Person implements NamedEntity {
			  name: String
			  age: Int
			}
			
			type Business implements NamedEntity & ValuedEntity {
			  name: String
			  value: Int
			  employeeCount: Int
			}
			
			type Contact {
			  entity: NamedEntity
			  phoneNumber: String
			  address: String
			}
		'''.shallParse
	}
	
//	@Test
//	def void exampleNo67(){
//		'''
//			extend interface NamedEntity {
//			  nickname: String
//			}
//			
//			extend type Person {
//			  nickname: String
//			}
//			
//			extend type Business {
//			  nickname: String
//			}
//		'''.doParse
//	}
	
//	@Test
//	def void exampleNo68(){
//		'''
//			extend interface NamedEntity @addedDirective
//		'''.doParse
//	}
		
	@Test
	def void exampleNo69(){
		'''
			union SearchResult = Photo | Person
			
			type Person {
			  name: String
			  age: Int
			}
			
			type Photo {
			  height: Int
			  width: Int
			}
			
			type SearchQuery {
			  firstSearchResult: SearchResult
			}
		'''.shallParse
	}
	
	@Test
	def void exampleNo72(){
		'''
			union SearchResult =
			  | Photo
			  | Person
		'''.shallParse
	}
	
	@Test
	def void exampleNo73(){
		'''
			enum Direction {
			  NORTH
			  EAST
			  SOUTH
			  WEST
			}
		'''.shallParse
	}
	
	@Test
	def void exampleNo74(){
		'''
			input Point2D {
			  x: Float
			  y: Float
			}
		'''.shallParse
	}
	
	@Test
	def void exampleNo75(){
		'''
			input ExampleInputObject {
			  a: String
			  b: Int!
			}
		'''.shallParse
	}
	
	@Test
	def void exampleNo80(){
		'''
			directive @example on
			  | FIELD
			  | FRAGMENT_SPREAD
			  | INLINE_FRAGMENT
		'''.shallParse
	}
	
	@Test
	def void exampleNo81(){
		'''
			directive @example on FIELD_DEFINITION | ARGUMENT_DEFINITION
			
			type SomeType {
			  field(arg: Int @example): String @example
			}
		'''.shallParse
	}
	
	@Test
	def void exampleNo85(){
		'''
			type ExampleType {
			  newField: String
			  oldField: String @deprecated(reason: "Use `newField`.")
			}
		'''.shallParse
	}
	
	@Test
	def void exampleNo86(){
		'''
			type User {
			  id: String
			  name: String
			  birthday: Date
			}
		'''.shallParse
	}
	
	@Test
	@Disabled("relevance and solution unclear")
	def void exampleSchemaIntrospection(){
		// TODO: "type" is an allowed field name
		// TODO: literals of "__TypeKind" and "__DirectiveLocation" is are keywords actually.
		//		But it is unclear if these would be allowed in own definitions or not. 
		'''
			type __Schema {
			  types: [__Type!]!
			  queryType: __Type!
			  mutationType: __Type
			  subscriptionType: __Type
			  directives: [__Directive!]!
			}
			
			type __Type {
			  kind: __TypeKind!
			  name: String
			  description: String
			
			  # OBJECT and INTERFACE only
			  fields(includeDeprecated: Boolean = false): [__Field!]
			
			  # OBJECT only
			  interfaces: [__Type!]
			
			  # INTERFACE and UNION only
			  possibleTypes: [__Type!]
			
			  # ENUM only
			  enumValues(includeDeprecated: Boolean = false): [__EnumValue!]
			
			  # INPUT_OBJECT only
			  inputFields: [__InputValue!]
			
			  # NON_NULL and LIST only
			  ofType: __Type
			}
			
			type __Field {
			  name: String!
			  description: String
			  args: [__InputValue!]!
			  type: __Type!
			  isDeprecated: Boolean!
			  deprecationReason: String
			}
			
			type __InputValue {
			  name: String!
			  description: String
			  type: __Type!
			  defaultValue: String
			}
			
			type __EnumValue {
			  name: String!
			  description: String
			  isDeprecated: Boolean!
			  deprecationReason: String
			}
			
			enum __TypeKind {
			  SCALAR
			  OBJECT
			  INTERFACE
			  UNION
			  ENUM
			  INPUT_OBJECT
			  LIST
			  NON_NULL
			}
			
			type __Directive {
			  name: String!
			  description: String
			  locations: [__DirectiveLocation!]!
			  args: [__InputValue!]!
			}
			
			enum __DirectiveLocation {
			  QUERY
			  MUTATION
			  SUBSCRIPTION
			  FIELD
			  FRAGMENT_DEFINITION
			  FRAGMENT_SPREAD
			  INLINE_FRAGMENT
			  SCHEMA
			  SCALAR
			  OBJECT
			  FIELD_DEFINITION
			  ARGUMENT_DEFINITION
			  INTERFACE
			  UNION
			  ENUM
			  ENUM_VALUE
			  INPUT_OBJECT
			  INPUT_FIELD_DEFINITION
			}
		'''.shallParse
	}
	
	@Test
	def void exampleValidation(){
		'''
			type Query {
			  dog: Dog
			}
			
			enum DogCommand { SIT, DOWN, HEEL }
			
			type Dog implements Pet {
			  name: String!
			  nickname: String
			  barkVolume: Int
			  doesKnowCommand(dogCommand: DogCommand!): Boolean!
			  isHousetrained(atOtherHomes: Boolean): Boolean!
			  owner: Human
			}
			
			interface Sentient {
			  name: String!
			}
			
			interface Pet {
			  name: String!
			}
			
			type Alien implements Sentient {
			  name: String!
			  homePlanet: String
			}
			
			type Human implements Sentient {
			  name: String!
			}
			
			enum CatCommand { JUMP }
			
			type Cat implements Pet {
			  name: String!
			  nickname: String
			  doesKnowCommand(catCommand: CatCommand!): Boolean!
			  meowVolume: Int
			}
			
			union CatOrDog = Cat | Dog
			union DogOrHuman = Dog | Human
			union HumanOrAlien = Human | Alien
		'''.shallParse
	}
	
	@Test
	def void exampleNo120(){
		// FIXME: "extend" is currently not supported
		'''
			type Arguments {
			  multipleReqs(x: Int!, y: Int!): Int!
			  booleanArgField(booleanArg: Boolean): Boolean
			  floatArgField(floatArg: Float): Float
			  intArgField(intArg: Int): Int
			  nonNullBooleanArgField(nonNullBooleanArg: Boolean!): Boolean!
			  booleanListArgField(booleanListArg: [Boolean]!): [Boolean]
			  optionalNonNullBooleanArgField(optionalBooleanArg: Boolean! = false): Boolean!
			}
			
«««			extend type Query {
«««			  arguments: Arguments
«««			}
		'''.shallParse
	}
}
