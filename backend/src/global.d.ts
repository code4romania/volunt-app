declare namespace Express {
  export interface Response {
    boom: any
  }
}
declare module '*.json' {
  const value: any
  export default value
}
declare module 'json!*' {
  const value: any
  export default value
}
