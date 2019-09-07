package asheiduk.graphqls.tests

import asheiduk.graphqls.graphQLS.Document
import com.google.inject.Inject
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.extensions.InjectionExtension
import org.eclipse.xtext.testing.util.ParseHelper
import org.junit.jupiter.api.Assertions
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
	def void exampleNo3(){
		'''
			{
			  user(id: 4) {
			    name
			  }
			}
		'''.shallParse
	}
	
	@Test
	def void exampleNo5(){
		'''
			mutation {
			  likeStory(storyID: 12345) {
			    story {
			      likeCount
			    }
			  }
			}
		'''.shallParse
	}
	
	@Test
	def void exampleNo6(){
		'''
			{
			  field
			}
		'''.shallParse
	}
	
	@Test
	def void exampleNo7(){
		'''
			{
			  id
			  firstName
			  lastName
			}
		'''.shallParse
	}
	
	@Test
	def void exampleNo8(){
		'''
			{
			  me {
			    id
			    firstName
			    lastName
			    birthday {
			      month
			      day
			    }
			    friends {
			      name
			    }
			  }
			}
		'''.shallParse
	}
	
	@Test
	def void exampleNo9(){
		'''
			# `me` could represent the currently logged in viewer.
			{
			  me {
			    name
			  }
			}
			
			# `user` represents one of many users in a graph of data, referred to by a
			# unique identifier.
			{
			  user(id: 4) {
			    name
			  }
			}
		'''.shallParse
	}
	
	@Test
	def void exampleNo10(){
		'''
			{
			  user(id: 4) {
			    id
			    name
			    profilePic(size: 100)
			  }
			}
		'''.shallParse
	}
	
	@Test
	def void exampleNo11(){
		'''
			{
			  user(id: 4) {
			    id
			    name
			    profilePic(width: 100, height: 50)
			  }
			}
		'''.shallParse
	}
	
	@Test
	def void exampleNo12(){
		'''
			{
			  picture(width: 200, height: 100)
			}
		'''.shallParse
	}
	
	@Test
	def void exampleNo13(){
		'''
			{
			  picture(height: 100, width: 200)
			}
		'''.shallParse
	}
	
	@Test
	def void exampleNo14(){
		'''
			{
			  user(id: 4) {
			    id
			    name
			    smallPic: profilePic(size: 64)
			    bigPic: profilePic(size: 1024)
			  }
			}
		'''.shallParse
	}
	
	@Test
	def void exampleNo16(){
		'''
			{
			  zuck: user(id: 4) {
			    id
			    name
			  }
			}
		'''.shallParse
	}
	
	@Test
	def void exampleNo18(){
		'''
			query noFragments {
			  user(id: 4) {
			    friends(first: 10) {
			      id
			      name
			      profilePic(size: 50)
			    }
			    mutualFriends(first: 10) {
			      id
			      name
			      profilePic(size: 50)
			    }
			  }
			}
		'''.shallParse
	}
	
	@Test
	def void exampleNo19(){
		'''
			query withFragments {
			  user(id: 4) {
			    friends(first: 10) {
			      ...friendFields
			    }
			    mutualFriends(first: 10) {
			      ...friendFields
			    }
			  }
			}
			
			fragment friendFields on User {
			  id
			  name
			  profilePic(size: 50)
			}
		'''.shallParse
	}
	
	@Test
	def void exampleNo20(){
		'''
			query withNestedFragments {
			  user(id: 4) {
			    friends(first: 10) {
			      ...friendFields
			    }
			    mutualFriends(first: 10) {
			      ...friendFields
			    }
			  }
			}
			
			fragment friendFields on User {
			  id
			  name
			  ...standardProfilePic
			}
			
			fragment standardProfilePic on User {
			  profilePic(size: 50)
			}
		'''.shallParse
	}
	
	@Test
	def void exampleNo21(){
		'''
			query FragmentTyping {
			  profiles(handles: ["zuck", "cocacola"]) {
			    handle
			    ...userFragment
			    ...pageFragment
			  }
			}
			
			fragment userFragment on User {
			  friends {
			    count
			  }
			}
			
			fragment pageFragment on Page {
			  likers {
			    count
			  }
			}
		'''.shallParse
	}
	
	@Test
	def void exampleNo23(){
		'''
			query inlineFragmentTyping {
			  profiles(handles: ["zuck", "cocacola"]) {
			    handle
			    ... on User {
			      friends {
			        count
			      }
			    }
			    ... on Page {
			      likers {
			        count
			      }
			    }
			  }
			}
		'''.shallParse
	}
	
	@Test
	def void exampleNo24(){
		'''
			query inlineFragmentNoType($expandedInfo: Boolean) {
			  user(handle: "zuck") {
			    id
			    name
			    ... @include(if: $expandedInfo) {
			      firstName
			      lastName
			      birthday
			    }
			  }
			}
		'''.shallParse
	}
	
	@Test
	def void exampleNo30(){
		'''
			{
			  nearestThing(location: { lon: 12.43, lat: -53.211 })
			}
		'''.shallParse
	}
	
	@Test
	def void exampleNo31(){
		'''
			{
			  nearestThing(location: { lat: -53.211, lon: 12.43 })
			}
		'''.shallParse
	}
	
	@Test
	def void exampleNo32(){
		'''
			query getZuckProfile($devicePicSize: Int) {
			  user(id: 4) {
			    id
			    name
			    profilePic(size: $devicePicSize)
			  }
			}
		'''.shallParse
	}
	
	@Test
	def void exampleNo34(){
		'''
			query {
			  myName
			}
		'''.shallParse
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
	def void exampleNo36(){
		'''
			mutation {
			  setName(name: "Zuck") {
			    newName
			  }
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
	def void exampleNo42(){
		'''
			{
			  name
			  age
			  picture
			}
		'''.shallParse
	}
	
	@Test
	def void exampleNo44(){
		'''
			{
			  age
			  name
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
	def void exampleNo48(){
		'''
			{
			  name
			  relationship {
			    name
			  }
			}
		'''.shallParse
	}
	
	@Test
	def void exampleNo50(){
		'''
			{
			  foo
			  ...Frag
			  qux
			}
			
			fragment Frag on Query {
			  bar
			  baz
			}
		'''.shallParse
	}
	
	@Test
	def void exampleNo52(){
		'''
			{
			  foo
			  ...Ignored
			  ...Matching
			  bar
			}
			
			fragment Ignored on UnknownType {
			  qux
			  baz
			}
			
			fragment Matching on Query {
			  bar
			  qux
			  foo
			}
		'''.shallParse
	}
	
	@Test
	def void exampleNo54(){
		'''
			{
			  foo @skip(if: true)
			  bar
			  foo
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
	def void exampleNo57(){
		'''
			{
			  name
			  picture(size: 600)
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
		
	@Test
	def void exampleNo60(){
		'''
			extend type Story {
			  isHiddenLocally: Boolean
			}
		'''.shallParse
	}
	
	@Test
	def void exampleNo61(){
		'''
			extend type User @addedDirective
		'''.shallParse
	}
	
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
	
	@Test
	def void exampleNo64(){
		'''
			{
			  entity {
			    name
			  }
			  phoneNumber
			}
		'''.shallParse
	}
	
	@Test
	def void exampleNo66(){
		'''
			{
			  entity {
			    name
			    ... on Person {
			      age
			    }
			  },
			  phoneNumber
			}
		'''.shallParse
	}
	
	@Test
	def void exampleNo67(){
		'''
			extend interface NamedEntity {
			  nickname: String
			}
			
			extend type Person {
			  nickname: String
			}
			
			extend type Business {
			  nickname: String
			}
		'''.shallParse
	}
	
	@Test
	def void exampleNo68(){
		'''
			extend interface NamedEntity @addedDirective
		'''.shallParse
	}
		
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
	def void exampleNo71(){
		'''
			{
			  firstSearchResult {
			    ... on Person {
			      name
			    }
			    ... on Photo {
			      height
			    }
			  }
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
	def void exampleNo78(){
		'''
			query withNullableVariable($var: String) {
			  fieldWithNonNullArg(nonNullArg: $var)
			}
		'''.shallParse
	}
	
	
	
	@Test
	def void exampleNo79(){
		'''
			directive @example on FIELD
			
			fragment SomeFragment on SomeType {
			  field @example
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
	def void exampleNo87(){
		'''
			{
			  __type(name: "User") {
			    name
			    fields {
			      name
			      type {
			        name
			      }
			    }
			  }
			}
		'''.shallParse
	}
	
	
	
	@Test
	def void exampleNo89(){
		'''
			input Point {
			  x: Int
			  y: Int
			}
		'''.shallParse
	}
	
	@Test
	def void exampleNo90(){
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
	def void exampleNo92(){
		'''
			query getDogName {
			  dog {
			    name
			  }
			}
			
			query getOwnerName {
			  dog {
			    owner {
			      name
			    }
			  }
			}
		'''.shallParse
	}
	
	@Test
	def void exampleNo95(){
		'''
			{
			  dog {
			    name
			  }
			}
		'''.shallParse
	}
	
	@Test
	def void exampleNo97(){
		'''
			subscription sub {
			  newMessage {
			    body
			    sender
			  }
			}
		'''.shallParse
	}
	
	@Test
	def void exampleNo98(){
		'''
			subscription sub {
			  ...newMessageFields
			}
			
			fragment newMessageFields on Subscription {
			  newMessage {
			    body
			    sender
			  }
			}
		'''.shallParse
	}
	
	@Test
	def void exampleNo103(){
		'''
			fragment interfaceFieldSelection on Pet {
			  name
			}
		'''.shallParse
	}
	
	@Test
	def void exampleNo105(){
		'''
			fragment inDirectFieldSelectionOnUnion on CatOrDog {
			  __typename
			  ... on Pet {
			    name
			  }
			  ... on Dog {
			    barkVolume
			  }
			}
		'''.shallParse
	}
	
	@Test
	def void exampleNo111(){
		'''
			fragment safeDifferingFields on Pet {
			  ... on Dog {
			    volume: barkVolume
			  }
			  ... on Cat {
			    volume: meowVolume
			  }
			}
			
			fragment safeDifferingArgs on Pet {
			  ... on Dog {
			    doesKnowCommand(dogCommand: SIT)
			  }
			  ... on Cat {
			    doesKnowCommand(catCommand: JUMP)
			  }
			}
		'''.shallParse
	}
	
	@Test
	def void exampleNo115(){
		'''
			extend type Query {
			  human: Human
			  pet: Pet
			  catOrDog: CatOrDog
			}
		'''.shallParse
	}
	
	@Test
	def void exampleNo117(){
		'''
			fragment argOnRequiredArg on Dog {
			  doesKnowCommand(dogCommand: SIT)
			}
			
			fragment argOnOptional on Dog {
			  isHousetrained(atOtherHomes: true) @include(if: true)
			}
		'''.shallParse
	}
	
	@Test
	def void exampleNo120(){
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
			
			extend type Query {
			  arguments: Arguments
			}
		'''.shallParse
	}
	
	@Test
	def void exampleNo121(){
		'''
			fragment multipleArgs on Arguments {
			  multipleReqs(x: 1, y: 2)
			}
			
			fragment multipleArgsReverseOrder on Arguments {
			  multipleReqs(y: 1, x: 2)
			}
		'''.shallParse
	}
	
	@Test
	def void exampleNo122(){
		'''
			fragment goodBooleanArg on Arguments {
			  booleanArgField(booleanArg: true)
			}
			
			fragment goodNonNullArg on Arguments {
			  nonNullBooleanArgField(nonNullBooleanArg: true)
			}
		'''.shallParse
	}
	
	@Test
	def void exampleNo126(){
		'''
			{
			  dog {
			    ...fragmentOne
			    ...fragmentTwo
			  }
			}
			
			fragment fragmentOne on Dog {
			  name
			}
			
			fragment fragmentTwo on Dog {
			  owner {
			    name
			  }
			}
		'''.shallParse
	}
	
	@Test
	def void exampleNo128(){
		'''
			fragment correctType on Dog {
			  name
			}
			
			fragment inlineFragment on Dog {
			  ... on Dog {
			    name
			  }
			}
			
			fragment inlineFragment2 on Dog {
			  ... @include(if: true) {
			    name
			  }
			}
		'''.shallParse
	}
	
	@Test
	def void exampleNo130(){
		'''
			fragment fragOnObject on Dog {
			  name
			}
			
			fragment fragOnInterface on Pet {
			  name
			}
			
			fragment fragOnUnion on CatOrDog {
			  ... on Dog {
			    name
			  }
			}
		'''.shallParse
	}
	
	@Test
	def void exampleNonum137(){
		'''
			fragment dogFragment on Dog {
			  ... on Dog {
			    barkVolume
			  }
			}
		'''.shallParse
	}
	
	// TODO: following tests
	
	@Test
	def void exampleNo155(){
		'''
			input ComplexInput { name: String, owner: String }
			
			extend type Query {
			  findDog(complex: ComplexInput): Dog
			  booleanList(booleanListArg: [Boolean!]): Boolean
			}
		'''.shallParse
	}
	
	@Test
	def void exampleSchemaIntrospection(){
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
}
